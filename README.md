# Table_for_Script
This is a useful table for Apple Script or Java Script users on Mac OS.  
It provides a table and many kinds of cells, text field, check box, popup menu, and color well.  
![](https://dl.dropbox.com/s/2batjkyx3piw4ip/tableForCreateAsCore.png?dl=0)  
## Sample Script
This script makes the table above. 


    Tell application "Table for Script"
        set pos to {"none","top/left","bottom/left","bottom/right","top/right"}
            set aData to {a Value:"(910,455,1820,910)",b value:"(1820,1820,910,455,1820)", a List:pos,  
            c Value:"1200", d Value:"1200", e Value:"400", f Value:"350", a Color:{0,0,0}, 
            b color:{25000,25000,25000}, g Value:"1", h Value:"30", i Value:"11"}  
    
        set tlts to {"List of abscissas", "List of ordinates", "Position of dim lines", "Length of extension", 
            "Length of dim's support lines", "Distance from as core to dim", "Distance from 1th dims to 2th dims", 
            "Color of as core", "Color of dim lines", "Code of thick of as core", "Code of line type of as core", 
            "Code of thick of dim line"} 
    
        set exp to "Create As cores script"
        set aResult to display table aData titles tlts explanation exp 
    
        if return code is 1 then 
    
            set xCod to list from text a Value of aResult
            set yCod to list from text b Value of aResult
            set posDim to a List of aResult 
            set byd to c Value of aResult as number
            set lgfrt to d Value of aResult as number
            set clnc to e Value of aResult as number
            set lgsec to f Value of aResult as number
            set cColor to a Color of aResult
            set dColor to b Color of aResult
            set wcd to g Value of aResult as number
            set dcd to h Value of aResult as number
            set sWcd to i Value of aResult as number 
    
        end if
        terminate
    end tell
