library(hexSticker)
library(magick)
imglocation <- "man/images/fysangarg.png"
mgkimage <- image_read(imglocation)
mgkimage_blur <- image_blur(mgkimage, 10, sigma = 1)

mgkimage_blur_location <- "man/images/fysangarg-blur2.png"
image_write(mgkimage_blur, mgkimage_blur_location)

mgkimage_blur_location <- "man/images/fysangarg-blur2.png"


plot(sticker(mgkimage_blur_location,
             package="fysan", p_size=28, s_x=1, s_y=1.25, s_width=.5, s_height = .5,
             filename="inst/figures/imgfile.png",
             h_color = rgb(75/255,156/255,211/255),
             h_fill = rgb(255/255,255/255,255/255),
             p_color = rgb(75/255,156/255,211/255),
             p_y = .7))

plot(sticker(mgkimage_blur_location,
             package="fysan", p_size=28, s_x=1, s_y=.78, s_width=.75, s_height = .75,
             filename="inst/figures/imgfile.png",
             h_color = rgb(75/255,156/255,211/255),
             h_fill = rgb(255/255,255/255,255/255),
             p_color = rgb(75/255,156/255,211/255),
             p_y = 1.5))

save_sticker("man/images/fysan-hex2.png")
