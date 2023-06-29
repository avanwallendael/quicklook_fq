#quicklook_fq


######1. Start#####
#list the files
mkdir temp
ls *q.gz > temp/files1.txt

directory="./"

# Count the total number of files in the directory
total_files=$(find "$directory" -type f -maxdepth 1| wc -l)

# Count the number of files with the extension q.gz
qgz_files=$(find "$directory" -type f -name "*q.gz" -maxdepth 1| wc -l)

# Compare the file counts
if [ "$total_files" -ne "$qgz_files" ]; then
  echo "hide non-fastq files"
fi

# List all files in the directory, sort by size in reverse order, and extract the file names
largest_file=$(ls -l "$directory" | grep "^-" | sort -k 5 -n -r | head -n 1 | awk '{print $NF}')
smallest_file=$(ls -l "$directory" | grep "^-" | sort -k 5 -n | head -n 1 | awk '{print $NF}')

# Print the number of fastqs
nfile=$(wc -l < temp/files1.txt)
echo "Found $nfile gzipped fastq files."

# Get the sizes of the largest and smallest files using ls -l
largest_size=$(ls -l "$largest_file" | awk '{print $5}')
smallest_size=$(ls -l "$smallest_file" | awk '{print $5}')

# Print the largest and smallest file names and sizes
echo "Largest file: $largest_file (Size: $largest_size bytes)"
echo "Smallest file: $smallest_file (Size: $smallest_size bytes)"

echo "If file sizes differ greatly (~10x or more), results may be biased. You should remove outlier files or trim them to the same size."

#####2. Sketch#####
mkdir outs
for sample in *q.gz; do ../mash sketch -m 2 -k 21 -s 10000 ${sample}; done
mv *msh outs

ls outs/*.msh > outs/list
../mash sketch -l outs/list
../mash dist outs/list.msh outs/list.msh > outs/tbl1_quicklook.tab
