#!/bin/bash

# Copyright 2020 Tomoki Hayashi
#  MIT License (https://opensource.org/licenses/MIT)

download_dir=$1

# check arguments
if [ $# != 1 ]; then
    echo "Usage: $0 <download_dir>"
    exit 1
fi

set -euo pipefail

base_url=http://www.openslr.org/resources/60
parts="dev-clean test-clean dev-other test-other train-clean-100 train-clean-360 train-other-500"

cwd=$(pwd)
if [ ! -e "${download_dir}/LibriTTS/.all_done" ]; then
    mkdir -p "${download_dir}"
    cd "${download_dir}" || exit 1;
    for part in ${parts}; do
        if [ -e ".${part}.all_done" ]; then
            echo "Download of ${part} is already finished. skipped."
        fi
        wget --no-check-certificate "${base_url}/${part}.tar.gz"
        tar xvzf "${part}.tar.gz"
        touch "LibriTTS/.${part}_done"
    done
    touch LibriTTS/.all_done
    cd "${cwd}" || exit 1;
    echo "Successfully downloaded data."
else
    echo "Already exists. Skipped."
fi

if [ ! -e "${download_dir}/LibriTTS/.lab_done" ]; then
    cd "${download_dir}" || exit 1;
    git clone https://github.com/kan-bayashi/LibriTTSCorpusLabel.git
    for part in ${parts}; do
        cp -r "LibriTTS-Alignment/${part}" ./LibriTTS
    done
    touch LibriTTS/.lab_done
    cd "${cwd}" || exit 1;
    echo "Successfully downloaded label data."
else
    echo "Already exists. Skipped."
fi
