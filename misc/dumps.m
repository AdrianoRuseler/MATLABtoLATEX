% dumps


    %     if options.DSPlot
    %         Save downsample por curve
    %         for s=0:wstruct{p}.main.numscreen-1 % Screens Loop
    %             DSxdata=wstruct{p}.main.xdata; %
    %             for c=0:eval(['wstruct{p}.screen' num2str(s) '.curvecount'])-1 % Curves Loop
    %                 DSydata = eval(['wstruct{p}.screen' num2str(s) '.curve' num2str(c) '.data']);
    %
    %                 hfig=dsplot(DSxdata, DSydata, options.DSpoints);
    %                 x=get(hfig,'XData');
    %                 y=get(hfig,'YData');
    %                 x=x(:); % force vector to be vertical
    %                 y=y(:);
    %
    %                 disp('Plot dowsampled points!!')
    %                 if options.ManualTips % Gets tips points from plot
    %                     if eval(['isfield(wstruct{p}.screen' num2str(s) '.curve' num2str(c) ',''tip'')'])
    %                         Well, we found some tips, move on;
    %                     else
    %                         grid on
    %                         xlim([xfrom  xto])
    %                         yfrom = eval(['wstruct{p}.screen' num2str(s) '.yfrom']);
    %                         yto = eval(['wstruct{p}.screen' num2str(s) '.yto']);
    %                         ylim([yfrom yto])
    %                         clabel = eval(['wstruct{p}.screen' num2str(s) '.curve' num2str(c) '.label']);
    %                         legend(clabel)
    %                         xlabel(wstruct{p}.main.xaxis)
    %                         title(['Get tip location for curve ' clabel])
    %
    %                         [xtip,ytip] = ginput(2); % Get two points for putting tips
    %                         Dxtip=xtip/(xto-xfrom); % Scales to get angle
    %                         Dytip=ytip/(yto-yfrom);
    %
    %                         tip.theta = round(angle((Dxtip(2)-Dxtip(1))+1i*(Dytip(2)-Dytip(1)))*180/pi);
    %                         tip.x=xtip(1); % Tip x position
    %                         tip.y=ytip(1); % Tip y position
    %                         if options.SetVar
    %                             prompt = {['Enter tip String for ' clabel]};
    %                             dlg_title = 'Input';
    %                             num_lines = 1;
    %                             def = {['$' clabel '$']};
    %                             answer = inputdlg(prompt,dlg_title,num_lines,def);
    %                             if isempty(answer)
    %                                 tip.string=['$' clabel '$']; % enters string value
    %                             else
    %                                 tip.string=answer{1};
    %                             end
    %                         else
    %                             tip.string=clabel; % enters string value
    %                         end
    %                         eval(['wstruct{p}.screen' num2str(s) '.curve' num2str(c) '.tip=tip;']);
    %                         eval(['wstruct{p}.screen' num2str(s) '.curve' num2str(c) '.tip'])
    %                         close(get(get(hfig,'Parent'),'Parent'))% Closes the figure
    %                     end
    %                 end % end of manual tips
    %
    %                 close(get(get(hfig,'Parent'),'Parent'))% Closes the figure
    %                   datatofit{p}=y; % Get this data for future use in labels
    %                 csvheader=['xdata, curve' num2str(c) ];
    %                 SCREENdata=[x y];
    %                 csvfilename = [dirstruct.psimstorage '\' plots{p} 'DSscreen' num2str(s) 'curve' num2str(c) '.csv'];
    %                 savecsvfile(SCREENdata, csvheader, csvfilename);
    %             end
    %         end
    %     end % end of DSplot