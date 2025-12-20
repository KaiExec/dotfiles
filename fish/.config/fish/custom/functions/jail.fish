# Aim is the criminal, Cell is the prison

function jail -a aim cell
    # Check if the dir is existent
    if not test -d "$aim"
        echo "Check if your aim is non-existent🫥"
        return
    end
    if not test -d "$cell"
        echo "Check if your cell is non-existent🫥"
        return
    end

    read -l cell_name -P "Enter Cell Name > "
    if test -d "$cell/$cell_name"
        read -l continue -P "$cell/$cell_name is existent, Overwrite? y/n > "
        if test $continue != y
            return
        end
        rm -rf $cell/$cell_name
    end

    # Bakcup
    mkdir -p $HOME/Temp/jail/
    cp -r "$aim" $HOME/Temp/jail/

    # Prepare
    set -l abs_aim (realpath $aim)
    set -l abs_cell (realpath $cell)
    set -l door (dirname $abs_aim)
    set -l jail_base (string replace (path dirname $abs_cell) "" $door)
    set -l location "$cell/$cell_name$jail_base"
    # Build
    mkdir -p "$location"
    # Move
    mv "$aim" "$location"

    # Conguraulation?
    echo -e "The Cell: $location/$(basename $aim)\nIt's alone now💀"
end
