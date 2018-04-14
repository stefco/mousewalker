function [indnose, indtail, Boundary] = FindTailNosePoints(NumberOfObjects, Boundary, CC, p, v)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function [indnose, indtail, Boundary] = FindTailNosePoints(NumberOfObjects, Boundary, CC, p, v)
%
% Find end of tail and nose.
%
% (c) Imre Bartos 2013
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% find tail and nose points -- I assume they are the farthest points from each other on the boundary
  for i = 1 : NumberOfObjects
    % I first just choose a random point (indx(1), indy(1)) and calculate the distance of each other point from it
      dist = (Boundary{i}(:,1) - Boundary{i}(1,1)).^2 + (Boundary{i}(:,2) - Boundary{i}(1,2)).^2;
    % find farthest point
      indfarthest{i} = find(dist == max(dist)); indfarthest{i} = indfarthest{i}(1);
    % now find farthest point from this farthest point -- this is probably either the nose or the tail 
      dist = (Boundary{i}(:,1) - Boundary{i}(indfarthest{i},1)).^2 + (Boundary{i}(:,2) - Boundary{i}(indfarthest{i},2)).^2;
      indfarthest{i} = find(dist == max(dist)); indfarthest{i} = indfarthest{i}(1);
    % and once more, but now its the other end
      dist = (Boundary{i}(:,1) - Boundary{i}(indfarthest{i},1)).^2 + (Boundary{i}(:,2) - Boundary{i}(indfarthest{i},2)).^2;
      indfarthest2{i} = find(dist == max(dist)); indfarthest2{i} = indfarthest2{i}(1);
    % if direction is not forced
      if p.ForceDirection == 1
      % find which one is head and which one is tail -- use the fact that the body gets thicker faster than the tail by checking the average distance of nearby points
        % find nearby points to extrema
          nearbypoints1 = [max(1,mod(length(Boundary{i}(:,1))+indfarthest{i}-50,length(Boundary{i}(:,1)))) max(1,mod(indfarthest{i}+50,length(Boundary{i}(:,1))))];
          nearbypoints2 = [max(1,mod(length(Boundary{i}(:,1))+indfarthest2{i}-50,length(Boundary{i}(:,1)))) max(1,mod(indfarthest2{i}+50,length(Boundary{i}(:,1))))];
        % find their distance from the extreme
          distance1 = (Boundary{i}(nearbypoints1(1),1) - Boundary{i}(nearbypoints1(2),1))^2 + (Boundary{i}(nearbypoints1(1),2) - Boundary{i}(nearbypoints1(2),2))^2;
          distance2 = (Boundary{i}(nearbypoints2(1),1) - Boundary{i}(nearbypoints2(2),1))^2 + (Boundary{i}(nearbypoints2(1),2) - Boundary{i}(nearbypoints2(2),2))^2;
        % the head should be the one with the greater distance
          if distance1 >= distance2
            indnose{i} = indfarthest{i};
            indtail{i} = indfarthest2{i};
          else
            indnose{i} = indfarthest2{i};
            indtail{i} = indfarthest{i};
          end;
      else % if direction of mouse is forced 
        if     p.ForceDirection == 2 % up
            One = Boundary{i}(indfarthest{i},1);
            Two = Boundary{i}(indfarthest2{i},1);
            Up = Boundary{i}(indfarthest{i},2);
            Down = Boundary{i}(indfarthest2{i},2);
          if Boundary{i}(indfarthest{i},1) < Boundary{i}(indfarthest2{i},1)
            indnose{i} = indfarthest{i};
            indtail{i} = indfarthest2{i};
          else
            indnose{i} = indfarthest2{i};
            indtail{i} = indfarthest{i};
          end;             
        elseif p.ForceDirection == 3 % down
          if Boundary{i}(indfarthest{i},1) > Boundary{i}(indfarthest2{i},1)
            indnose{i} = indfarthest{i};
            indtail{i} = indfarthest2{i};
          else
            indnose{i} = indfarthest2{i};
            indtail{i} = indfarthest{i};
          end;          
        elseif p.ForceDirection == 4 % left 
          if Boundary{i}(indfarthest{i},2) < Boundary{i}(indfarthest2{i},2)
            indnose{i} = indfarthest{i};
            indtail{i} = indfarthest2{i};
          else
            indnose{i} = indfarthest2{i};
            indtail{i} = indfarthest{i};
          end;
        elseif p.ForceDirection == 5 % right
          if Boundary{i}(indfarthest{i},2) > Boundary{i}(indfarthest2{i},2)
            indnose{i} = indfarthest{i};
            indtail{i} = indfarthest2{i};
          else
            indnose{i} = indfarthest2{i};
            indtail{i} = indfarthest{i};
          end;          
        elseif p.ForceDirection == 6 % based on previous one
          % find which one is head and which one is tail -- use the fact that the body gets thicker faster than the tail by checking the average distance of nearby points
            % find nearby points to extrema
              nearbypoints1 = [max(1,mod(length(Boundary{i}(:,1))+indfarthest{i}-50,length(Boundary{i}(:,1)))) max(1,mod(indfarthest{i}+50,length(Boundary{i}(:,1))))];
              nearbypoints2 = [max(1,mod(length(Boundary{i}(:,1))+indfarthest2{i}-50,length(Boundary{i}(:,1)))) max(1,mod(indfarthest2{i}+50,length(Boundary{i}(:,1))))];
            % find their distance from the extreme
              distance1 = (Boundary{i}(nearbypoints1(1),1) - Boundary{i}(nearbypoints1(2),1))^2 + (Boundary{i}(nearbypoints1(1),2) - Boundary{i}(nearbypoints1(2),2))^2;
              distance2 = (Boundary{i}(nearbypoints2(1),1) - Boundary{i}(nearbypoints2(2),1))^2 + (Boundary{i}(nearbypoints2(1),2) - Boundary{i}(nearbypoints2(2),2))^2;
            % the head should be the one with the greater distance
              if distance1 >= distance2
                indnose{i} = indfarthest{i};
                indtail{i} = indfarthest2{i};
              else
                indnose{i} = indfarthest2{i};
                indtail{i} = indfarthest{i};
              end;
          % only if there is previous mouse
            if v.MouseTrack.NumberOfMice > 0
              % define min distance of current mouse center from previous one
                minDist = 9999;
              % find previous mouse that overlaps with current one
                for j = 1:v.MouseTrack.NumberOfMice
                  % find previous frame
                    indPreviousFrame = find(v.MouseTrack.TrackIndex{j} == p.FrameIndex-1);
                    if ~isempty(indPreviousFrame)
                      % distance between body center on previous frame and current frame
                        Distance = (v.MouseTrack.Nose{j}(indPreviousFrame,1) - Boundary{i}(indfarthest{i},1))^2 + (v.MouseTrack.Nose{j}(indPreviousFrame,2) - Boundary{i}(indfarthest{i},2))^2;
                        Distance2 = (v.MouseTrack.Nose{j}(indPreviousFrame,1) - Boundary{i}(indfarthest2{i},1))^2 + (v.MouseTrack.Nose{j}(indPreviousFrame,2) - Boundary{i}(indfarthest2{i},2))^2;
                      % if any of these are the closest so far, make that one the nose
                        if Distance < minDist
                          minDist = Distance;
                          indnose{i} = indfarthest{i};
                          indtail{i} = indfarthest2{i};
                        end;
                        if Distance2 < minDist
                          minDist = Distance2;
                          indnose{i} = indfarthest2{i};
                          indtail{i} = indfarthest{i};
                        end;
                    end;
                end;
            end
        end;        
      end;
    % reorganize points such that the nose should have index 1;
      % get length of bondary
        L = length(Boundary{i});
      % extend data as if it was circular so we can than cut the right part
        B = [Boundary{i}; Boundary{i}];
      % make starting point the one at the head and cut off extra
        Boundary{i} = B(indnose{i}:indnose{i}+L-1,:);
      % move indnose and indtail to their position in this new Boundary
        indtail{i} = mod(indtail{i} - indnose{i} + 1 + L,L); 
        if indtail{i} == 0, indtail{i} = L; end;
        indnose{i} = 1;
  end;  

  

return;