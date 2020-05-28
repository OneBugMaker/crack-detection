# crack-detection
edge detection + CNN

To run the code.ipynb you should change train epoch to > 1000.

first step: download data from : http://hydinin.com:8086/phm/article11.html, and save it in folder named code.
second step: run all_xtx.m on Matlab, and ensure its result to folder named new_data.
third step: run code.ipynb on jupyter notebook.


The files are saved like:

all_xtx.m
code.ipynb
----data
    ----pos
        ----1.jpg
        ----2.jpg
        ...
    ----neg
        ----1.jpg
        ----2.jpg
        ...
----new_data
    ----pos
        ----1.jpg
        ----2.jpg
        ...
    ----neg
        ----1.jpg
        ----2.jpg
        ...
----save
    model.h5
    
