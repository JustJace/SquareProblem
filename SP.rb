# RUBY SQUARE PROBLEM

$N = 3
$THRESHOLD = -1
$SUMTHRESHOLD = -1
$MAXDEPTH = 3
$solution

# DISPLAY

def display solution

	for row in solution
		print row
		puts
	end
	puts "SUM = #{sum_of solution}"
end

# SQUARE

def valid_diagonals? square

	for y in 0...$N
		for x in 0...$N
			next if square[y][x] == 0
			#if x > 0 && y > 0
			#       return false if divide_equally? square[x][y], square[x-1][y-1]
			#end
			if x > 0 && y < $N - 1
				return false if divide_equally? square[y][x], square[y+1][x-1]
			end
			#if x < $N - 1 && y > 0
			#       return false if divide_equally? square[x][y], square[x+1][y-1]
			#end
			if x < $N - 1 && y < $N - 1
				return false if divide_equally? square[y][x], square[y+1][x+1]
			end
		end
	end

   return true
end

def heuristic_squares

	configurations = []
	nums = []
	for i in 2..(1 + $N**2 / 2)
		nums.push i
	end

	for permute in nums.permutation
		square = new_square
		if valid_diagonals? (create_lattice square, permute)
			configurations.push square
		end
	end

	return configurations
end

def create_lattice square, permute

	i = 0
	j = 0
	for y in 0...$N
		for x in 0...$N
			if i % 2 == 0
				i += 1
				next
			end

			i += 1
			square[y][x] = permute[ j ]			
			j += 1		
		end
		if $N % 2 == 0
			i += 1
		end
	end
	return square

end

def new_square

	square = []
	for i in 0...$N
		row = []
		for j in 0...$N
			row.push 0
		end
		square.push row
	end

	return square
end

def dup_square square

	dupSquare = []

	for row in square
		dupSquare.push row.dup
	end

	return dupSquare
end

# SOLVE

def full? square

	return !(square.flatten.include? 0)
end


def next_spot_in square

	for y in 0...$N
		for x in 0...$N
			return x,y if square[y][x] == 0
		end
	end
end

def place_next square, i

	dupSquare = dup_square square
	x,y = next_spot_in square
	dupSquare[y][x] = i 
	return dupSquare
end

def divide_equally? i, j

	return i % j == 0 || j % i == 0
end

def valid_next? square, x, y, i

	# Check Orthogonals
	if x > 0 && square[y][x-1] != 0
		return false if !divide_equally? square[y][x-1], i
	end
	if x < $N - 1 && square[y][x+1] != 0
		return false if !divide_equally? square[y][x+1], i
	end
	if y > 0 && square[y-1][x] != 0
		return false if !divide_equally? square[y-1][x], i
	end
	if y < $N - 1 && square[y+1][x] != 0
		return false if !divide_equally? square[y+1][x], i
	end

	# Check Diagonals
	if x > 0 && y > 0 && square[y-1][x-1] != 0
		return false if divide_equally? square[y-1][x-1], i
	end
	# if x > 0 && y < $N - 1 && square[x-1][y+1] != 0
	# 	return false if divide_equally? square[x-1][y+1], i
	# end
	if x < $N - 1 && y > 0 && square[y-1][x+1] != 0
		return false if divide_equally? square[y-1][x+1], i
	end
	# if x < $N - 1 && y < $N - 1 && square[x+1][y+1] != 0
	# 	return false if divide_equally? square[x+1][y+1], i
	# end

	return true
end

def valid_list square

	valid = []
	x, y = next_spot_in square

	for i in 2..$THRESHOLD
		if valid_next? square, x, y, i
			valid.push i
		end
	end

	for i in square.flatten
		valid.delete i
	end

	return valid
end

def sum_of square

	return square.flatten.inject {|sum, n| sum + n}
end

def heuristic_trim? square, sum

	n = $N**2 - (square.flatten.count 0)
	d = $N**2

	if sum * 1.2 > ((n.to_f / d.to_f) * $SUMTHRESHOLD)
		#puts "#{sum} > #{(n.to_f / d.to_f) * $SUMTHRESHOLD}"
		return true
	end

	return false
end

def solve square

	sum = sum_of square

	if full? square
		if sum < $SUMTHRESHOLD
			$SUMTHRESHOLD = sum
			$THRESHOLD = 3 * sum / $N**2
			$solution = square
			display square
		end
		return
	end

	return if sum > $SUMTHRESHOLD
	return if heuristic_trim? square, sum

	for i in valid_list square
		solve place_next(square, i)
	end
end


# MAIN

$N = ARGV[0].to_i if ARGV[0] != nil

if ARGV[1] == '-h'

	$THRESHOLD = $N**3 * 2.5
	$SUMTHRESHOLD = $THRESHOLD * ($N**2 / 2)


	nums = []
	for i in 2..(1 + $N**2 / 2)
		nums.push i
	end
	for permute in nums.permutation
		square = new_square
		if valid_diagonals? (create_lattice square, permute)
			solve square
		end
	end

	# hSquares = heuristic_squares
	# puts "Heuristic Configurations: #{hSquares.length}"
	# for configuration in hSquares
	# 	solve configuration
	# end

	if $solution == nil
		puts "Could not find solution by heuristic lattice."
	end
end

i = 2 * $N

while $solution == nil && i < $MAXDEPTH * $N
	$THRESHOLD = 2**i
	$SUMTHRESHOLD = $THRESHOLD * ($N**2 / 2)
	solve new_square
	i += 1
end

display $solution