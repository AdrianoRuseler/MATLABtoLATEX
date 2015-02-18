%*** Copyright (c) 2014, Chad Greene
%*** All rights reserved.
%*** 
%*** Redistribution and use in source and binary forms, with or without
%*** modification, are permitted provided that the following conditions are
%*** met:
%*** 
%***     * Redistributions of source code must retain the above copyright
%***       notice, this list of conditions and the following disclaimer.
%***     * Redistributions in binary form must reproduce the above copyright
%***       notice, this list of conditions and the following disclaimer in
%***       the documentation and/or other materials provided with the distribution
%*** 
%*** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
%*** AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
%*** IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
%*** ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
%*** LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
%*** CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
%*** SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
%*** INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
%*** CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
%*** ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
%*** POSSIBILITY OF SUCH DAMAGE.

function [ hex ] = rgb2hex(rgb)
% rgb2hex converts rgb color values to hex color format. 
% 
% This function assumes rgb values are in [r g b] format on the 0 to 1
% scale.  If, however, any value r, g, or b exceed 1, the function assumes
% [r g b] are scaled between 0 and 255. 
% 
% * * * * * * * * * * * * * * * * * * * * 
% SYNTAX:
% hex = rgb2hex(rgb) returns the hexadecimal color value of the n x 3 rgb
%                    values. rgb can be an array. 
% 
% * * * * * * * * * * * * * * * * * * * * 
% EXAMPLES: 
% 
% myhexvalue = rgb2hex([0 1 0])
%    = #00FF00
% 
% myhexvalue = rgb2hex([0 255 0])
%    = #00FF00
% 
% myrgbvalues = [.2 .3 .4;
%                .5 .6 .7; 
%                .8 .6 .2;
%                .2 .2 .9];
% myhexvalues = rgb2hex(myrgbvalues) 
%    = #334D66
%      #8099B3
%      #CC9933
%      #3333E6
% 
% * * * * * * * * * * * * * * * * * * * * 
% Chad A. Greene, April 2014
% 
% Updated August 2014: Functionality remains exactly the same, but it's a
% little more efficient and more robust. Thanks to Stephen Cobeldick for
% his suggestions. 
% 
% * * * * * * * * * * * * * * * * * * * * 
% See also hex2rgb, dec2hex, hex2num, and ColorSpec. 

%% Check inputs: 

assert(nargin==1,'This function requires an RGB input.') 
assert(isnumeric(rgb)==1,'Function input must be numeric.') 

sizergb = size(rgb); 
assert(sizergb(2)==3,'rgb value must have three components in the form [r g b].')
assert(max(rgb(:))<=255& min(rgb(:))>=0,'rgb values must be on a scale of 0 to 1 or 0 to 255')

%% If no value in RGB exceeds unity, scale from 0 to 255: 
if max(rgb(:))<=1
    rgb = round(rgb*255); 
else
    rgb = round(rgb); 
end

%% Convert (Thanks to Stephen Cobeldick for this clever, efficient solution):

hex(:,2:7) = reshape(sprintf('%02X',rgb.'),6,[]).'; 
hex(:,1) = '#';


end
