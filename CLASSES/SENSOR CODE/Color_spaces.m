I =  imread('Photo_RGB.jpg');
imshow(I);

%RGB Colour space
rmat = I(:,:,1);
gmat = I(:,:,2);
bmat = I(:,:,3);

figure;
subplot(2,2,1), imshow(rmat);
title('Red Plane');
subplot(2,2,2), imshow(gmat);
title('Green Plane');
subplot(2,2,3), imshow(bmat);
title('Blue Plane');
subplot(2,2,4), imshow(I);
title('Original image');
