# RUBY SQUARE PROBLEM

#############################################################
def display square
	for y in 0...$N
		for x in 0...$N
			print "#{square[y*$N + x]} "
		end
		puts
	end
	puts "SUM: #{sum_of square} TIME: #{Time.now - $ST}"
end
#############################################################
def divide_equally? a, b
	return false if a == 0 || b == 0
	return a % b == 0 || b % a == 0
end
#############################################################
def create_div_table
	table = []
	for y in 0...$MAXNUM
		row = []
		for x in 0...$MAXNUM
			row.push divide_equally? x,y
		end
		table.push row
	end
	return table
end
#############################################################
def full? square
	return !(square.include? 0)
end
#############################################################
def sum_of square
	return square.inject {|sum, n| sum + n}
end
#############################################################
def next_lo_spot_in square

	if square.count(0) != 0
		for i in (square.length-1).downto(0)
			if square[i] != 0
				x = i
				break
			end
		end
		return 0 if x == nil # 1 for N=3, ? for N=4, 0 for N=5, ? for N=7
		if $N % 2 != 0
			return x + 2
		else
			if x % 2 == 0
				if x % $N > $N/2 - 1
					return x + 3
				else
					return x + 2
				end
			else
				if x % $N > $N/2 - 1
					return x + 1
				else
					return x + 2
				end
			end
		end
	end

	return 0 # or potentially 1 for N={odd}, 1 for N=3, 0 for N=5, ? for N=7
end
#############################################################
def next_hi_spot_in square
	return square.index 0
end
#############################################################
def place_hi num, square
	x = next_hi_spot_in square
	copy = square.dup
	copy[x] = num
	return copy
end
#############################################################
def place_lo num, square
	x = next_lo_spot_in square
	copy = square.dup
	copy[x] = num
	return copy
end
#############################################################
def valid_num? square, num, x
	$L = 0
	$U = 0
	$R = 0
	$D = 0
	$UL = 0
	$UR = 0
	$DR = 0
	$DL = 0
	#LEFT
	if x % $N > 0 && square[x-1] != 0
		$L = square[x-1]
		return false if !$DIVEQL[square[x-1]][num]
	end
	#	UPLEFT
	if x % $N > 0 && x / $N > 0 && square[x-$N-1] != 0
		$UL = square[x-$N-1]
		return false if $DIVEQL[square[x-$N-1]][num]
	end
	#UP
	if x / $N > 0 && square[x-$N] != 0
		$U = square[x-$N]
		return false if !$DIVEQL[square[x-$N]][num]
	end
	#UPRIGHT
	if x % $N < $N-1 && x / $N > 0 && square[x-$N+1] != 0
		$UR = square[x-$N+1]
		return false if $DIVEQL[square[x-$N+1]][num]
	end
	#RIGHT
	if x % $N < $N-1 && square[x+1] != 0
		$R = square[x+1]
		return false if !$DIVEQL[square[x+1]][num]
	end
	#DOWNRIGHT
	if x / $N < $N-1 && x % $N < $N-1 && square[x+$N+1] != 0
		$DR = square[x+$N+1]
		return false if $DIVEQL[square[x+$N+1]][num]
	end
	#DOWN
	if x / $N < $N-1 && square[x+$N] != 0
		$D = square[x+$N]
		return false if !$DIVEQL[square[x+$N]][num]
	end
	#DOWNLEFT
	if x % $N > 0 && x / $N < $N-1 && square[x+$N-1] != 0
		$DL = square[x+$N-1]
		return false if $DIVEQL[square[x+$N-1]][num]
	end

	# if full_lattice? square
	# 	puts
	# 	display square
	# 	puts "Num: #{num} X: #{x} L: #{$L} #{$DIVEQL[$L][num]} U: #{$U} #{$DIVEQL[$U][num]} R: #{$R} #{$DIVEQL[$R][num]} D: #{$D} #{$DIVEQL[$D][num]} UL: #{$UL} #{$DIVEQL[$UL][num]} UR: #{$UR} #{$DIVEQL[$UR][num]} DR: #{$DR} #{$DIVEQL[$DR][num]} DL: #{$DL} #{$DIVEQL[$DL][num]}"
	# end
	return true
end
#############################################################
def valid_lo_nums_in square
	x = next_lo_spot_in square
	valid = []
	$LOSET.each { |n| valid.push n if valid_num? square, n, x }
	square.each { |s| valid.delete s }
	return valid
end
#############################################################
def valid_hi_nums_in square
	x = next_hi_spot_in square
	valid = []
	$HISET.each { |n| valid.push n if valid_num? square, n, x}
	square.each { |s| valid.delete s }
	return valid
end
#############################################################
def current_sum_trim? square, sum
	n = $N**2 - (square.count 0)
	d = $N**2

	return true if sum > ((n.to_f / d.to_f) * $MINSUM)
	return false
end
#############################################################
def full_lattice? square

	return true if square[-1] != 0 #|| square[-2] != 0
	return false
end
#############################################################
def solve_hi square
	current_sum = sum_of square

	if full? square
		if current_sum < $MINSUM
			display square
			$MINSUM = current_sum
			$SOL = square
		end
		return
	end

	# display square

	return if current_sum > $MINSUM
	return if current_sum_trim? square, current_sum
	# return if square[$N*($N-1)]!= 0 && square[$N*($N-1)] < square[$N-1]
	# return if square[$N-1] != 0 && square[$N-1] < square[0]

	valid_hi_nums_in(square).each { |num| solve_hi place_hi num, square }
end
#############################################################
def solve_lo square
	current_sum = sum_of square

	return if current_sum > $MINSUM
	return if current_sum_trim? square, current_sum
	return if square[$N*($N-1)]!= 0 && square[$N*($N-1)] < square[$N-1]
	return if square[$N-1] != 0 && square[$N-1] < square[0]

	if !full_lattice? square
		valid_lo_nums_in(square).each { |num| solve_lo place_lo num, square }
	else
		solve_hi square
	end
end
#############################################################

$ST = Time.now
$N = ARGV[0].to_i
$MAXNUM = 2**($N + 3)
$MINSUM = $MAXNUM * $N**2 / 2
$HISET = 2...$MAXNUM
$LOSET = 2...$N**2
$SOL = nil
$DIVEQL = create_div_table
solve_lo Array.new($N**2, 0)
puts "END TIME: #{Time.now - $ST}"