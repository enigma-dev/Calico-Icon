#!/bin/bash

ignored_icons="Icon_Sprite Icon_Sound Icon_Background Icon_Path Icon_Script Icon_Font Icon_Timeline Icon_Object Icon_Room Icon_Model3D Icon_Definitions Icon_Overworld Icon_Extension Icon_Folder Icon_OpenFolder Icon_Folder2 Icon_OpenFolder2 Icon_Bug_Basic"

icons=`inkscape -S icons.svg | grep -o "^Icon_\\w\\+"`

mkdir -p raster

for icon in $icons
do
  outname=raster/$icon.png
  if [[ $ignored_icons =~ $icon ]] || [ -e $outname ]; then
    continue;
  fi
  
  # Calculate the screen coordinates of the icon, since InkScape is FAR, FAR too fucking stupid
  # to do this for you in any sensible way. Don't bother exporting the images with the --export-area-snap
  # option; that can't align them to a grid, only to whole pixels. And it can't round, only floor/ceil.
  # And then you have to use that piece of shit, ImageMagick, to make them the correct size. FUCK ImageMagick.
  # For that matter, FUCK INKSCAPE! Get your shit straight! It's cool that you thought it would help novices
  # cope if (0,0) was the fucking top-left corner, even though for your most advanced users, that's completely
  # fucking counter-intuitive. I can respect this decision. My request is, BE FUCKING CONSISTENT! I query for
  # coordinates, I get the logical coordinates, from the top left. I ask you to render, and you want your
  # fucking bullshit coordinates from the bottom-left. WHAT THE FUCK? Well, I'm over it, because I can just
  # query for the document height and subtract it, right? WRONG! YOU FUCKS DON'T SUPPORT THAT, EITHER! You just
  # give me some bullshit decimal calculation of how much drawing space I'm using. You left me LITERALLY no way
  # of doing this with your program. I had to hard-code the damn document height because you offered NO means of
  # obtaining it any other way. Thanks. Your program is amazingly intuitive, as a GUI. Too bad everything about
  # the code, spec, and CLI are totally fucking disgustingly back-asswards ugly.
  
  x=`inkscape icons.svg --query-id="$icon" --query-x`; x=`echo "scale=0;($x+9)/18*18" | bc`;
  if [[ -z "$x" ]]
  then 
    echo "Failed to export icon '$icon'".
    continue;
  fi
  y=`inkscape icons.svg --query-id="$icon" --query-y`; y=`echo "scale=0;($y+9)/18*18" | bc`;
  y=$((800-y-18))
  x2=$((x+18))
  y2=$((y+18))
  inkscape icons.svg --export-id=$icon --export-area=$x:$y:$x2:$y2 --export-id-only --export-png=$outname
  
  # Doesn't work because fuck InkScape.
  #inkscape icons.svg --export-id=Icon_$icon --export-area-snap --export-id-only --export-plain-svg=individual/Icon_$icon.svg
done

echo "Icon export complete";
