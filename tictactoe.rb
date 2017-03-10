#!/usr/bin/env ruby

require "awesome_print"

# def isGameOver(board)
#     if (board.contains? "XXX") || (board.contains? "OOO")
#         return true
#     else
#         3.times { |i|
#             if (board[i] == board[i+3]) && (board[i+3] == board[i+6])
#                 return true
#             end
#         }
#     end
# end

def isGameOver(board)
    return !(/(\w)(..(\1|.\1.)..\1|.\1.\1..$|\1\1(...)*$)/.match(board).nil?) || !board.include?(".")
end

def get_all_possible_moves(current_board, player)
    result = []
    # puts "current_board: "+current_board # debug
    array_current_board = current_board.split("")
    # puts "array_current_board: "+array_current_board.to_s # debug
    array_current_board.each_with_index { |square,i|
        # puts "square: "+square.to_s # debug
        if square=='.'
            temp = current_board.dup
            temp[i]=player
            result << temp
        end
    }
    # puts "result: "+result.to_s # debug
    return result
end

def find_all_boards(parent, player)
    boards = {}
    boards[parent] = []
    get_all_possible_moves(parent, player).each { |new_board|
        boards[parent] << new_board;
        if(!isGameOver(new_board))
            next_player = (player == 'O') ? 'X' : 'O';
            boards.merge!(find_all_boards(new_board, next_player));
        end
    }
    # puts "boards: "+boards.to_s # debug
    return boards
end

parent = ".XO......"
# parent = "........."
player = 'O'

result_hash = find_all_boards(parent,player);

output="strict digraph \"velha\" {\n"
result_hash.each_key { |key|
    result_hash[key].each { |value|
        output+="\t\"#{key}\" -> \"#{value}\"\n"
    }
}
output+="}"

puts output