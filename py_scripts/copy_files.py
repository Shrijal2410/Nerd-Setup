import shutil
import os
import concurrent.futures
import time
from tqdm import tqdm

src_files = [r"G:\My Drive\Takeout\takeout-20231127T073409Z-007.zip"]
dest_folder = "D:"

def file_size(file_path):
    return os.path.getsize(file_path)

def format_size(size_bytes):
    return f"{size_bytes / (1024 * 1024 * 1024):.2f} GB" if size_bytes > 1024 * 1024 else f"{size_bytes / (1024 * 1024):.2f} MB"

def copy_file(src_file, dest_folder, progress_bar):
    size_bytes = file_size(src_file)
    size_format = format_size(size_bytes)
    chunk_size = 1024 * 1024  # 1 MB chunk size

    with open(src_file, "rb") as source, \
         open(os.path.join(dest_folder, os.path.basename(src_file)), "wb") as destination:
        
        start_time = time.time()

        for chunk in iter(lambda: source.read(chunk_size), b''):
            destination.write(chunk)
            progress_bar.update(len(chunk))

    dest_path = os.path.join(dest_folder, os.path.basename(src_file))
    progress_bar.set_postfix(file=f"{dest_path}")
    print(f"\nFile '{src_file}' successfully copied to '{dest_path}'!")

    return dest_path

# Driver code
total_bytes = sum(file_size(src) for src in src_files)
total_format = format_size(total_bytes)

with tqdm(total=total_bytes, desc=f"Total Progress ({total_format})", unit_scale=True, position=0) as overall_bar:
    def process_file(src):
        try:
            return copy_file(src, dest_folder, overall_bar)
        except Exception as e:
            return f"Error: {e}"

    with concurrent.futures.ThreadPoolExecutor() as executor:
        results = list(executor.map(process_file, src_files))

# Process the results if needed
for result in results:
    if isinstance(result, str) and result.startswith("Error"):
        print(result)