#!/bin/bash

for i in *.png;
  do mv -f "${i}" ${i/' [www.imagesplitter.net]'/};
done;
