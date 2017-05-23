classdef Copyable < matlab.mixin.Copyable
   methods (Access = protected)
      function copy = copyElement(this)
         copy = copyElement@matlab.mixin.Copyable(this);

         fields = fieldnames(this);
         for i = 1:length(fields)
           try
             copy.(fields(i)) = this.(fields(i)).copy();
           catch
             copy.(fields(i)) = this.(fields(i));
           end
         end
      end
   end
end