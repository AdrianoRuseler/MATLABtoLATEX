% =========================================================================
%*** Displays struct content
%***
%***
% =========================================================================

function status=structdisp(STRUCTdata)

STRUCTdata=SCOPEdata


if isfield(STRUCTdata,'simview')
    disp(STRUCTdata.simview)
end

if isfield(STRUCTdata,'setstruct')

fields=fieldnames(STRUCTdata.setstruct)
    disp(STRUCTdata.setstruct)


end




