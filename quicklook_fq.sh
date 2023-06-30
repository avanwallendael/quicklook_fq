######1. Start#####
#list the files
mkdir temp
ls *q.gz > temp/files1.txt

directory="./"

# List all files in the directory, sort by size in reverse order, and extract the file names
largest_file=$(ls -l "$directory" | grep "^-" | sort -k 5 -n -r | head -n 1 | awk '{print $NF}')
smallest_file=$(ls -l "$directory" | grep "^-" | sort -k 5 -n | head -n 1 | awk '{print $NF}')

# Print the number of fastqs
nfile=$(wc -l < temp/files1.txt)
echo "Found $nfile gzipped fastq files."
echo " "
# Get the sizes of the largest and smallest files using ls -l
largest_size=$(ls -l "$largest_file" | awk '{print $5}')
smallest_size=$(ls -l "$smallest_file" | awk '{print $5}')

# Print the largest and smallest file names and sizes
echo "Largest file: $largest_file (Size: $largest_size bytes)"
echo "Smallest file: $smallest_file (Size: $smallest_size bytes)"
echo " "
echo "If file sizes differ greatly (~10x or more), results may be biased. You should remove outlier files or trim them to the same size."
echo " " 
echo "Starting mash sketch"

#####2. Sketch#####
mkdir outs
#check type of unix system to count the number of available threads
if [[ $(uname -s) == "Darwin" ]]; then
  num_threads=$(sysctl -n hw.logicalcpu)
else
  num_threads=$(nproc)
fi

# Run the command in parallel using all but one thread
find . -type f -name "*q.gz" | xargs -P $num_threads -I {} ../mash sketch -m 2 -k 21 -s 10000 {}

mv *msh outs

ls outs/*.msh > outs/list
../mash sketch -l outs/list
../mash dist outs/list.msh outs/list.msh > outs/tbl1_quicklook.tab
