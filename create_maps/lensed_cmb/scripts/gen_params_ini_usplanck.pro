PRO gen_params_ini_usplanck
	
	nsim = 100
	
	for i=0, nsim-1 do begin
		sidx = strcompress(string(i), /remove_all)
		filename = 'params/params_'+sidx+'.ini'
		openw, 10, filename
		printf, 10, 'w8dir = /global/homes/h/hou/Projects/CMBtools/Healpix_2.20a/data/'
		printf, 10, 'nside = 8192'
		printf, 10, 'lmax = 4500'
		printf, 10, 'cls_file = /global/homes/h/hou/Projects/projects/sptsz_lowl/sptsz_sims/create_maps/lensed_cmb/data/lcdm_wmap7k11_lenspotentialCls.dat'
		printf, 10, 'out_file_root = /global/scratch2/sd/hou/data/sptsz_lowl/create_maps/lensed_cmb/lensed_cmb'
		printf, 10, 'out_file_suffix = sim'+sidx
		printf, 10, 'lens_method = 1'
		printf, 10, 'interp_factor = 0.375'
		printf, 10, 'interp_method = 1'
		printf, 10, 'mpi_division_method = 3'
		printf, 10, 'want_pol = F'
        printf, 10, 'want_map = T'
        printf, 10, 'want_alm = F'
        printf, 10, 'rand_seed = '+strcompress(string(i*25L), /remove_all)
		close, 10
	endfor
	
	filename = 'submit.sh'
	openw, 10, filename
	printf, 10, '#PBS -S /bin/bash'
	printf, 10, '#PBS -q usplanck'
	printf, 10, '#PBS -l nodes=32:ppn=1'
	printf, 10, '#PBS -l pvmem=20GB'
	printf, 10, '#PBS -l walltime=8:00:00'
	printf, 10, '#PBS -m abe'
	printf, 10, '#PBS -j oe'
	printf, 10, '#PBS -A usplanck'
	printf, 10, '#PBS -N lsim'
	printf, 10, '#PBS -e $PBS_JOBID.err'
	printf, 10, '#PBS -o $PBS_JOBID.out'
	printf, 10, '#PBS -V'
	printf, 10, ' '
	printf, 10, 'cd $PBS_O_WORKDIR'
    printf, 10, 'module load intel'
    printf, 10, 'module load openmpi-intel'
    printf, 10, 'export OMP_NUM_THREADS=8'
	printf, 10, ' '
	for i=0, nsim-1 do begin
		sidx = strcompress(string(i), /remove_all)
		printf, 10, 'mpirun -np 32 -bynode /global/u1/h/hou/Projects/projects/sptsz_lowl/sptsz_sims/create_maps/lensed_cmb/lenspix_src/simlens params/params_'+sidx+'.ini'
	endfor
	close, 10

END
