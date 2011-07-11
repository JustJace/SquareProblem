# RUBY SQUARE PROBLEM

$N = 3
$THRESHOLD = -1
$SUMTHRESHOLD = -1
$solutions = []

# DISPLAY

def display solution

	for row in solution
		print row
		puts
	end
	puts "SUM = #{sum solution}"
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
			return x,y if square[x][y] == 0
		end
	end
end

def place_next square, i

	dupSquare = dup_square square
	x,y = next_spot_in square
	dupSquare[x][y] = i 
	return dupSquare
end

def divide_equally? i, j

	return i % j == 0 || j % i == 0
end

def valid_next? square, x, y, i

	# Check Orthogonals
	if x > 0 && square[x-1][y] != 0
		return false if !divide_equally? square[x-1][y], i
	end
	if x < $N - 1 && square[x+1][y] != 0
		return false if !divide_equally? square[x+1][y], i
	end
	if y > 0 && square[x][y-1] != 0
		return false if !divide_equally? square[x][y-1], i
	end
	if y < $N - 1 && square[x][y+1] != 0
		return false if !divide_equally? square[x][y+1], i
	end

	# Check Diagonals
	if x > 0 && y > 0 && square[x-1][y-1] != 0
		return false if divide_equally? square[x-1][y-1], i
	end
	if x > 0 && y < $N - 1 && square[x-1][y+1] != 0
		return false if divide_equally? square[x-1][y+1], i
	end
	if x < $N - 1 && y > 0 && square[x+1][y-1] != 0
		return false if divide_equally? square[x+1][y-1], i
	end
	if x < $N - 1 && y < $N - 1 && square[x+1][y+1] != 0
		return false if divide_equally? square[x+1][y+1], i
	end

	return true
end

def remove_dups valid, square

	for i in square.flatten
		if valid.include? i
			valid.delete i
		end
	end

	return valid
end

def valid_list square

	valid = []
	x, y = next_spot_in square

	for i in 2..$THRESHOLD
		if valid_next? square, x, y, i
			valid.push i
		end
	end

	return remove_dups valid, square
end

def sum square

	return square.flatten.inject {|sum, n| sum + n}
end

def minimum_sum

	min_square = []
	min = 2**32

	for solution in $solutions
		if (sum solution) < min
			min_square = solution
			min = sum solution
		end
	end

	return min_square
end

def solve square

	if full? square
		$solutions.push square
		if (sum square) < $SUMTHRESHOLD
			$SUMTHRESHOLD = sum square
		end

		return
	end

	return if (sum square) > $SUMTHRESHOLD

	for i in valid_list square
		solve place_next(square, i)
	end
end


# MAIN

$N = ARGV[0].to_i if ARGV[0] != nil

i = 1

while $solutions.length == 0
	$THRESHOLD = 2**i
	$SUMTHRESHOLD = $THRESHOLD * ($N**2-1)
	solve new_square
	i += 1
end

display minimum_sum