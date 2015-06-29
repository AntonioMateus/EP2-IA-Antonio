function [result] = mod_adj (num1, num2)
    result = mod(num1,num2); 
    if result == 0
        result = num2; 
    end
end
