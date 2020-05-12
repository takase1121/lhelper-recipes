package="$1"
version="$2"
shift 2

with_list=(zlib bzip2 png harfbuzz brotli)
with_in=()
options=()
while [ ! -z ${1+x} ]; do
    case $1 in
    -brotli)
        with_in+=(brotli)
        ;;
    *)
        options+=("$1")
        ;;
    esac
    shift
done

for name in "${with_in[@]}"; do
    options+=("--with-$name=yes")
done
for name in "${with_list[@]}"; do
    if [[ " ${with_in[*]} " != *" $name "* ]]; then
        options+=("--with-$name=no")
    fi
done

# Note for 2.10.2 the gz file seems wrong because gzipped twice,
# use xz instead.
zip=xz
enter_remote_archive "freetype-${version}" "http://download.savannah.gnu.org/releases/freetype/freetype-${version}.tar.$zip" "freetype-${version}.tar.$zip" "tar xf ARCHIVE_FILENAME"
build_and_install configure "${options[@]}"
