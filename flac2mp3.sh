#!/bin/bash
# You need flac and lame utils
# On OS X you can install them usung homebrew: $ brew install lame flac

for f in "$@"; do
    [[ "$f" != *.flac ]] && continue
    album="$(metaflac --show-tag=album "$f" | sed 's/[^=]*=//')"
    artist="$(metaflac --show-tag=artist "$f" | sed 's/[^=]*=//')"
    date="$(metaflac --show-tag=date "$f" | sed 's/[^=]*=//')"
    title="$(metaflac --show-tag=title "$f" | sed 's/[^=]*=//')"
    tracknumber="$(metaflac --show-tag=tracknumber "$f" | sed 's/[^=]*=//')"

    flac --decode --stdout "$f" | lame --preset extreme --add-id3v2 --tt "$title" --ta "$artist" --tl "$album" --ty "$year" --tn "$tracknumber" - "${f%.flac}.mp3"
done
