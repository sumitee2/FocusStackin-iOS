# FocusStackin-iOS
# Objective C Code to combine images, which are similar but focussed on different areas of the scene, into one clearer whole

This function # focusStackImages in ViewController.m is the entry point

# The Algorithm Used:
- Loop over the images with a 5x5 Gaussian Kernel and calculate weight for each pixel
- Loop over the outputs of the previous with a Laplacian kernel to detect areas with strong edges
- In the array of images from step 2, for each pixel in the desired image, find the highest weight and use the corresponding pixel from the original image.

