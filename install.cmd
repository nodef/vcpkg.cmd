@echo off
@setlocal enabledelayedexpansion
:: We want to download vcpkg in the current directory
set "repo=repo"
git clone https://github.com/Microsoft/vcpkg %repo% --depth 1
robocopy "%repo%" . /e /move /nfl /ndl /njh /njs /np /nc /ns /xd "%repo%\.git"
:: Now, lets install vcpkg
bootstrap-vcpkg -disableMetrics
vcpkg integrate install
