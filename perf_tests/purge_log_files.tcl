set dirs [glob -nocomplain -type d *]
if { [llength $dirs] > 0 } {    
    foreach dir [lsort $dirs]   {	
		file copy -force delete_logs.tcl $dir/.
		cd $dir
		exec tclsh delete_logs.tcl
		cd ..
	}
}
	