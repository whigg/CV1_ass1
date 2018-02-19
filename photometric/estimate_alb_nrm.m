function [ albedo, normal ] = estimate_alb_nrm( image_stack, scriptV, shadow_trick)
warning('off','all')
%COMPUTE_SURFACE_GRADIENT compute the gradient of the surface
%   image_stack : the images of the desired surface stacked up on the 3rd
%   dimension
%   scriptV : matrix V (in the algorithm) of source and camera information
%   shadow_trick: (true/false) whether or not to use shadow trick in solving
%   	linear equations
%   albedo : the surface albedo
%   normal : the surface normal

[h, w, no_images] = size(image_stack);
if nargin == 2
    shadow_trick = true;
end

scriptV

% create arrays for 
%   albedo (1 channel)
%   normal (3 channels)
albedo = zeros(h, w, 1); % 512x512 matrix
normal = zeros(h, w, 3); % 512x512x3 matrix

% =========================================================================
% YOUR CODE GOES HERE
% for each point in the image array
%   stack image values into a vector i
%   construct the diagonal matrix scriptI
%   solve scriptI * scriptV * g = scriptI * i to obtain g for this point
%   albedo at this point is |g|
%   normal at this point is g / |g|

for x = 1:w % image width; 512 pixels
    for y = 1:h % image height; 512 pixels

        i = reshape(image_stack(x, y, :), [no_images, 1]); % 5x1 matrix
        scriptI = diag(i); % 5x5 matrix
        
        % mldivide(A, B) solves the system of linear equations A*x = B
        if shadow_trick == true
            A = scriptI * scriptV; % 5x3 matrix
            B = scriptI * i; % 5x1 matrix
            g = mldivide(A, B); % 5x1 matrix
        else
            g = mldivide(scriptV, i); % 5x1 matrix
        end
        
        albedo(y, x, 1) = sqrt(sum(g.^2));
        if sum(g) ~= 0
            normal(y, x, :) = g / sqrt(sum(g.^2));        
        end
    end
end

% =========================================================================

end

