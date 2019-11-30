function mean_img = meanfilt(img, windowsize)
 %Mean filter computes output image by applying a mean filter with
 %the windowsize.
  border = [floor(windowsize(1)/2), floor(windowsize(2)/2)];
  mask = 1/prod(windowsize)*ones(windowsize);
  
  % method to keep boundaries 
  %mean_img = conv2(img,mask,'same');
  %mean_img(1,:) = img(1,:); mean_img(size(img,1),:) = img(size(img,1),:);
  %mean_img(:,1) = img(:,1); mean_img(:,size(img,2)) = img(:,size(img,2));
  
  % best method
  imgpad = padarray(img,[border(1) border(2)],'symmetric','both');
  mean_img = conv2(imgpad,mask,'valid');
end
