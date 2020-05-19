#!/bin/bash
echo "Reifying..."
gringo $1/theory.lp $2 --output=reify > ./outputs/$1/instance_reified.lp
echo "Solving.."
clingo ./outputs/$1/instance_reified.lp $1/flc.lp -n 0 > ./outputs/$1/flc.lp
cat ./outputs/$1/flc.lp
echo "Removing.."
sed -i "" '1,3d' ./outputs/$1/flc.lp
echo "Replacing.."
sed -i "" $'s/) /).\\\n/g' ./outputs/$1/flc.lp
