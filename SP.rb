# RUBY SQUARE PROBLEM

# DISPLAY

def display solution

	solution.each {|row| print row, "\n"}
	puts "SUM = #{sum_of solution}"
end

# SQUARE

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
	square.each {|row| dupSquare.push row.dup}
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

def divide_equally? a,b

	return a % b == 0 || b % a == 0
end

def valid_next? square, x, y, i

	# Check Orthogonals
	if x > 0 && square[y][x-1] != 0
		return false if !divide_equally? square[y][x-1], i
	end
	#if x < $N - 1 && square[y][x+1] != 0
	#	return false if !divide_equally? square[y][x+1], i
	#end
	if y > 0 && square[y-1][x] != 0
		return false if !divide_equally? square[y-1][x], i
	end
	#if y < $N - 1 && square[y+1][x] != 0
	#	return false if !divide_equally? square[y+1][x], i
	#end

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

	if $H && (x % 2 == 0 && y == 0) || (x > 0 && y > 0 && ($LATTICE.include? square[y-1][x-1]))
		vals = $LATTICE
	else
		vals = 2..$THRESHOLD
	end


	vals.each {|i| valid.push i if valid_next? square, x, y, i}
	square.flatten.each {|i| valid.delete i}
	return valid
end

def sum_of square
	return square.flatten.inject {|sum, n| sum + n}
end

def heuristic_trim? square, sum

	n = $N**2 - (square.flatten.count 0)
	d = $N**2

	return true if sum > ((n.to_f / d.to_f) * $SUMTHRESHOLD)
	return false
end

def solve square

	sum = sum_of square

	if full? square
		if sum < $SUMTHRESHOLD
			$SUMTHRESHOLD = sum
			$SOLUTION = square
			display square
		end
		return
	end

	return if sum > $SUMTHRESHOLD
	return if heuristic_trim? square, sum
	valid_list(square).each {|num| solve place_next(square, num)}
end



# MAIN
$N = ARGV[0].to_i
$N = 3 if ARGV[0] == nil
$H = if ARGV[1] == '-h'
		true
	else
		false
	end
$THRESHOLD = 2**($N + 3)
$SUMTHRESHOLD = $THRESHOLD * $N**2 / 2
$SOLUTION = nil
$LATTICE = 2..($N**2+2)
solve new_square