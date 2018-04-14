function testsomething()

i = 1;
Xlim{i} = [0 6.1];
ExperimentName = 'Zsuzsa2';
LineWidth = 2;
x = 0:0.01:6.2;
p.outputFolderName = './Videos/Zsuzsa2/Results41';

      h = figure('visible', 'off','PaperPosition', [0 0 22 14], 'Units', 'inches');
      
     % FOOTPRINT TIMING ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~     
        h1 = subplot(5,2,[1 3]);
        subplot('Position',[0.05 0.7 0.45 0.25], 'FontSize', 14);
        plot(x,cos(x));
        ylim([-150 250]);
        box on;
        set(gca,'LineWidth',2);

      % TEXT ON SCREEN ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      % Things have to be between 0 and 1 (both x and y coordinates)
        LineWidth = 40;      
        % mean body speed
          MeanBodySpeed = 1123;
          text(Xlim{i}(1),-1000-1*LineWidth,['Speed [mm/s]:       ' num2str(   MeanBodySpeed   )],'FontSize', 20,'FontName','FixedWidth');
        % name of data
        text(Xlim{i}(1),-1000-2*LineWidth,['Data name: ' ExperimentName '  (#' num2str(i) ')'],'FontSize', 20,'FontName','FixedWidth', 'Interpreter', 'None');        
        
        
    % BODY SPEED ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      % define subplot
        h2 = subplot(5,2,5);
        subplot('Position',[0.05 0.55 0.45 0.15], 'FontSize', 14);
      % plot body speed
        plot(x,sin(x));
        box on;
        set(gca,'LineWidth',2);
        
        
    % COMBINATION ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      % define subplot
        h3 = subplot(5,2,7);
        subplot('Position',[0.05 0.4 0.45 0.15], 'FontSize', 14);
      % plot body speed
        plot(x,sin(x));
        box on;
        set(gca,'LineWidth',2);
        
    % FOOTPRINT TOTAL BRIGHTNESS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      % define subplot
        h4 = subplot(5,2,9);
        subplot('Position',[0.05 0.2 0.45 0.2], 'FontSize', 14);  
      % plot footprint total brightness
        plot(x,sin(x)+cos(x));
        legend('Location', 'NE');
        grid on;
        set(gca,'FontSize', 14);
        xlabel('Time [s]');
        ylabel('Total footprint size [mm^2]');
        box on;
        set(gca,'LineWidth',2);
        hold off;    
        xlim(Xlim{i});

          
    % STEP RELATIVE POSITION
      % define plot
        h4 = subplot(5,2,[2 4 6 8]);
        subplot('Position',[0.55 0.1 0.4 0.85], 'FontSize', 14)    

      % plot step relative positions 
        plot(x,sin(x)-cos(x));
        box on;
        set(gca,'LineWidth',2);
        
        
        
        
    % save figure
      outputfilename = [p.outputFolderName '/TEST_' ExperimentName '_' num2str(i) '.png'];
      saveas(h,outputfilename,'png');    
      close(h);        
        
        

return