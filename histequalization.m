function [counts,s,eq_im] = histequalization(image,gray_levels)
    counts = zeros(gray_levels, 1);
    for i = 0 : gray_levels-1
        counts(i+1) = sum(sum(image == i)); % counting pixels of every bin corresponding to i-th gray level
    end

    pdf = counts / numel(image); % calcolate pdf of image dividing by number of total pixels
    s = round((gray_levels-1) * cumsum(pdf)); % transf. fct and round the float to the nearest int

    eq_im = uint8(zeros(size(image))); % need uint8 value to render it
    for j = 1 : size(s, 1)
        eq_im(image == j-1) = s(j); % map value of s to respective pixel of that gray-level in  image
    end
    eq_im = reshape(eq_im, size(image)); % reshape to mat
end

