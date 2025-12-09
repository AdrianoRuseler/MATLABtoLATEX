
function validname = getname(testname)
 % verifies if this name can be used in matlab struct enviroment
     if verLessThan('matlab', '8.2.0')
         % -- Put code to run under MATLAB 8.2.0 and earlier here --
          validname = genvarname(lower(testname));
     else
         % -- Put code to run under MATLAB 8.2.0 and later here --
          validname = matlab.lang.makeValidName(lower(testname));
     end
return;