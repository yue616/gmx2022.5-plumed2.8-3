single precision Gromacs-2022.5 and patched with plumed-2.8.3, it only runs in CPU.

#for user run docker in linux:

docker run --rm -v $PWD:/home/gmx/Gromacs -w /home/gmx/Gromacs gmx-plumed:2022.5 gmx -f em.mdp -c em.gro -p topol.top -o em.tpr

#for user run docker in windows, the $PWD command must be replaced by the absolute path of your local directory, for example:

docker run --rm -v /d/Gromcas/jobs:/home/gmx/Gromacs -w /home/gmx/Gromacs gmx-plumed:2022.5 gmx -f em.mdp -c em.gro -p topol.top -o em.tpr