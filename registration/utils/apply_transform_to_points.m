function registered = apply_transform_to_points(moving,tform)
% transforms points (nx3) using affine tform (4x4)

moving = [moving ones(length(moving),1)];
registered = moving*tform;
registered = registered(:,1:3);
end