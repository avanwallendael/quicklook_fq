# quicklook_fq
Very fast distance estimation for fastqs

The goal of quicklook_fq is to provide a very fast and dependency-free tool for estimating genetic distance from genomic data. It is intended as a first-pass step in a large population genomics project to see patterns and catch errors in data. However, it is flexible enough to be useful for anything that uses a **fastq input** and a **distance matrix output**. 

The program is a simple wrapper for the mash program (https://github.com/marbl/mash; Ondov et al. 2016), with an optional step for plotting in R. Mash uses the minhash algorithm to randomly sample genomic k-mers, then convert them into computational hashes for rapid comparison. It has some advantages and disadvantages over traditional alignment-based analyses (VanWallendael & Alvarez 2021). Advantages: extremely fast, avoids pitfalls of alignment (poor or missing reference, reference bias, polyploidy, repetition). Disadvantages: sensitive to sequencing depth, misses variation in sampling, sensitive to contamination.

To run quicklook_fq, you should have a directory that includes both the mash executable and the quicklook_fq.sh executable, as well as a subdirectory with *only* your gzipped fastq files. 

**Installation**

There is no true installation step, but you must download and modify ownership to run both. 

#1. Download the mash and quicklook_fq executables  
#Choose the appropriate .tar from https://github.com/marbl/Mash/releases  
#download quicklook_fq.sh (or copy the code into a text file on your machine).

#2. Unzip the mash .tar  
tar -xf ~/Downloads/mash-OSX64-v2.3.tar  

#3. Move the executables into your working directory  
mkdir ~/Desktop/genomics  
mv ~/Downloads/mash-OSX64-v2.3/mash ~/Desktop/genomics  
mv ~/Downloads/quicklook_fq.sh ~/Desktop/genomics  
cd ~/Desktop/genomics  

#4. modify permissions  
chmod 777 mash  
chmod 777 quicklook_fq.sh  

**Running quicklook_fq**

You should have all of your fastqs (and only fastqs) in a folder in your working directory.

#5. Navigate to your fastq folder  
cd fastqs

#6. Run the script  
../quicklook_fq.sh

#7. Visualize your data  
R --vanilla < quicklook_fastq_plot.R


The visualization generated is a PDF showing a principal coordinates analysis of your samples, labeled by file name. If you have a list of populations that corresponds to filenames, check the commented-out code in the script that will allow you to color points by population. 
