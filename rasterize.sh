#!/bin/bash

ignored_icons="Icon_Sprite Icon_Sound Icon_Background Icon_Path Icon_Script Icon_Font Icon_Timeline Icon_Object Icon_Room Icon_Model3D Icon_Definitions Icon_Overworld Icon_Extension Icon_Folder Icon_OpenFolder Icon_Folder2 Icon_OpenFolder2 Icon_Bug_Basic"

styles=("" "-dark" "-16" "-24" "-32");
heights=(800 800 16 24 32);
sizes=(18 18 16 24 32);
for i in {0..3}; do
  style=${styles[i]}
  pageheight=${heights[i]}
  iconsz=${sizes[i]}
  
  mkdir -p raster$style;
  iconinfo=`inkscape -S icons$style.svg`;
  icons=`echo "$iconinfo" | grep -o "^Icon_\\w\\+"`;
  iconcount=`echo "$icons" | wc -l`;

  echo "Exporting icons$style.svg ($pageheight px high, icon size $iconsz, about $iconcount icons)";
  
  for icon in $icons; do
    outname=raster$style/$icon.png
    
    if [[ $ignored_icons =~ $icon ]]; then
      echo "- Skipping $icon...";
      continue;
    elif [ -e "$outname" ]; then
      echo "- Nothing to do for $icon...";
      continue;
    fi
    
    props=($(IFS=,; for i in $(echo "$iconinfo" | grep "^$icon,"); do echo $i; done));
    x=${props[1]}
    y=${props[2]}

    if [[ -z "$x" || -z "$y" ]]; then 
      echo "Failed to export icon '$icon'.";
      continue;
    fi
    
    roundbias=$((iconsz/2))
    x=$(printf '%.0f\n' $x)
    y=$(printf '%.0f\n' $y)
    
    x=$(echo "scale=0; ($x)/$iconsz*$iconsz" | bc);
    y=$(echo "scale=0; ($pageheight-(($y+$roundbias)/$iconsz*$iconsz)-$iconsz)/1" | bc);
    x2=$((x+iconsz));
    y2=$((y+iconsz));
    echo inkscape "icons$style.svg" --export-id="$icon" --export-area="$x:$y:$x2:$y2" --export-id-only --export-png="$outname"
    inkscape "icons$style.svg" --export-id="$icon" --export-area="$x:$y:$x2:$y2" --export-id-only --export-png="$outname"
  done
done # style loop



echo "Icon export complete";
