#~ RUBY SQUARE PROBLEM ~#

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
def display square
	buffer = ''
	for y in 0...$N
		for x in 0...$N
			buffer << "\t#{square[y*$N + x]}"
		end
		buffer << "\n"
	end
	buffer << "\nSUM: #{sum_of square} TIME: #{Time.now - $ST}\n"
	buffer << "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n"
	puts buffer
end
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
def divide_equally? a, b
	return false if a == 0 || b == 0
	return a % b == 0 || b % a == 0
end
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
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
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
def full? square
	return !(square.include? 0)
end
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
def sum_of square
	return square.inject {|sum, n| sum + n}
end
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
def next_spot_in square
	return square.index 0
end
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
def place num, square
	x = next_spot_in square
	copy = square.dup
	copy[x] = num
	return copy
end
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
def valid_num? square, num, x
	#LEFT
	if x % $N > 0 && square[x-1] != 0
		return false if !$DIVEQL[square[x-1]][num]
	end
	#UPLEFT
	if x % $N > 0 && x / $N > 0 && square[x-$N-1] != 0
		return false if $DIVEQL[square[x-$N-1]][num]
	end
	#UP
	if x / $N > 0 && square[x-$N] != 0
		return false if !$DIVEQL[square[x-$N]][num]
	end
	#UPRIGHT
	if x % $N < $N-1 && x / $N > 0 && square[x-$N+1] != 0
		return false if $DIVEQL[square[x-$N+1]][num]
	end
	# #RIGHT
	# if x % $N < $N-1 && square[x+1] != 0
	# 	return false if !$DIVEQL[square[x+1]][num]
	# end
	# #DOWNRIGHT
	# if x / $N < $N-1 && x % $N < $N-1 && square[x+$N+1] != 0
	# 	return false if $DIVEQL[square[x+$N+1]][num]
	# end
	# #DOWN
	# if x / $N < $N-1 && square[x+$N] != 0
	# 	return false if !$DIVEQL[square[x+$N]][num]
	# end
	# #DOWNLEFT
	# if x % $N > 0 && x / $N < $N-1 && square[x+$N-1] != 0
	# 	return false if $DIVEQL[square[x+$N-1]][num]
	# end
	return true
end
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
def valid_nums_in square
	x = next_spot_in square
	valid = []
	vals = if (x % 2 == ( $N == 3 ? 1 : 0) && x / $N == 0) || (x % $N > 0 && x / $N > 0 && ($LOSET.include? square[x-$N-1]))
			$LOSET
		  else
		  	$HISET
		  end
	vals.each { |n| valid.push n if valid_num? square, n, x}
	square.each { |s| valid.delete s }
	return valid
end
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
def current_sum_trim? square, sum
	n = $N**2 - (square.count 0)
	d = $N**2

	return true if sum > ((n.to_f / d.to_f) * $MINSUM)
	return false
end
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
def solve square
	current_sum = sum_of square

	if full? square
		if current_sum < $MINSUM
			$MINSUM = current_sum
			$SOL = square
			display square
		end
		return
	end


	return if current_sum > $MINSUM
	return if current_sum_trim? square, current_sum
	return if square[0] > square[$N**2 - 1]
	return if square[$N*($N-1)]!= 0 && square[$N*($N-1)] < square[$N-1]
	return if square[$N-1] != 0 && square[$N-1] < square[0]

	valid_nums_in(square).each { |num| solve place num, square }
end
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

$ST = Time.now
$N = ARGV[0].to_i
$MAXNUM = 2**($N + 3)
$MINSUM = $MAXNUM * $N**2 / 2
$HISET = 2...$MAXNUM
$LOSET = 2...$N**2
$SOL = nil
$DIVEQL = create_div_table
processorCount = 1
processes = []
PID = Process.pid
for i in 0...processorCount
	break if Process.pid != PID
	processes << fork {
		threads = []
		for j in (i * $MAXNUM / 4)...((i+1)*$MAXNUM / 4 - 1)
			threads << Thread.new {
				square = Array.new($N**2, 0)
				square[$N**2 - 1] = j
				solve square
			}
		end

		threads.each {|thread| thread.join}
	}

end

processes.each {|pid| Process.waitpid pid}

puts "Solution for N = #{$N} in #{$HISET}"
puts
display $SOL
