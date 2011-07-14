class SMath

	def self.create_div_table n

		table = []

		for y in 0...n
			row = []
			for x in 0...n
				row.push divide_equally? x,y
			end
			table.push row
		end

		return table
	end

	def self.divide_equally? a,b

		return false if a == 0 || b == 0
		return a % b == 0 || b % a == 0
	end

	def self.new_square n

		square = []
		for a in 0...n
			square[a].push 0
		end
	end
end