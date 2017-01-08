% TRXD_plots.m
% Produces plots of strain components and rocking curves
% May be called from either within of after TRXD.m


function [centroid FWHM] = TRXD_plots (A,time,angle,Strain,z,opts)

z = z*1e6; % Convert depth to um for plotting
time = time*1e9; % Convert time to ns for plotting
angle = angle*1e3; % Convert degrees to mdeg for plotting

trans_status = max(max(Strain(:,:,2)))>1e-10; % 0 if no transverse strain
sheer_status = max(max(Strain(:,:,2)))>1e-10; % 0 if no sheer strain

if strcmp(opts,'animate')==1
  fprintf('Animating plots at each timepoint.\n')
  figure(1);clf;
  figure(2);clf;
  figure(3);clf;
  figure(6);clf;
  figure(7);clf;
end

if strcmp(opts,'animate')==1 && trans_status == 1
  figure(4);clf;
end

if strcmp(opts,'animate')==1 && trans_status == 1
  figure(5);clf;
end


%% Plot at each time
for i = 1:length(time)

  longitudinal = Strain(i,:,1);
  transverse = Strain(i,:,2);
  sheer = Strain(i,:,3);
  Int = A(i,:).*conj(A(i,:)); % x-ray intensity
  centroid(i) = sum(Int.*angle)/sum(Int);
  FWHM(i) = 2*sqrt(2*log(2))*sqrt((1/(length(angle)-1))*sum(Int.*(angle-centroid(i)).^2));

  if strcmp(opts,'animate')==1
  
  figure(1)
    plot(angle,Int);hold on;
    title([ num2str(time(i)) ' ns']);
    xlabel('Angle (deg)');
    ylabel('Diffraction Intensity')
  hold off; 
  
  figure(2)
    semilogy(angle,Int);hold on;
    title([ num2str(time(i)) ' ns']);
    xlabel('Angle (deg)');
    ylabel('Diffraction Intensity')
  hold off; 
  
  figure(3)
    plot(z,longitudinal);hold on;
    title([ num2str(time(i)) ' ns']);
    xlabel('Depth (um)');
    ylabel('Longituidnal Strain')
  hold off;  
  
  % Only plot transverse strain if it is nonzero
  if trans_status == 1 
    figure(4)
     plot(z,transverse);hold on;
     title([ num2str(time(i)) ' ns']);
     xlabel('Depth (um)');
     ylabel('Transverse Strain')
    hold off;  
  end
  
  % Only plot sheer strain if it is nonzero
  if sheer_status == 1
    figure(5)
      plot(z,sheer);hold on;
      title([ num2str(time(i)) ' ns']);
      xlabel('Depth (um)');
      ylabel('Sheer Strain')
    hold off;  
  end 
  
  figure(6);hold on;
    plot(time(i),centroid(i),'o');
    xlabel('Time (ns)');
    ylabel('Centroid (mdeg)');
  hold off

  figure(7);hold on;
    plot(time(i),FWHM(i),'o');
    xlabel('Time (ns)');
    ylabel('FWHM (mdeg)');
  hold off
  
  pause(0.5); % To allow plots to animate smoothly
  
  end
  
  end % End Time loop
  
  if strcmp(opts,'none')~=0
  
  figure(10);clf; hold on
  
  subplot(2,2,1)
    plot(time,centroid,'o')
    xlabel('Time (ns)')
    ylabel('Centroid (mdeg)')
  
  subplot(2,2,2)
    plot(time,FWHM,'o')
    xlabel('Time (ns)')
    ylabel('FWHM (mdeg)')
  
  subplot(2,2,3)
    surf(time,angle,(A.*conj(A))','LineStyle','none')
    ylabel('Angle (mdeg)')
    xlabel('Time (ns)')
    title('Linear Scale')
    view(2)
    grid off
    ylim([-1*max(centroid) 2.5*max(centroid)])
    xlim([time(1) time(end)])
  
  subplot(2,2,4)
    surf(time,angle,(log(A.*conj(A)))','LineStyle','none')
    ylabel('Angle (mdeg)')
    xlabel('Time (ns)')
    title('Log Scale')
    view(2)
    grid off
    ylim([min(angle) max(angle)])
    xlim([time(1) time(end)])

  end
  
end

