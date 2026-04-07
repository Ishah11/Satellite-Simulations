# SPARCS & ISS Orbital Animation

This repository contains MATLAB scripts designed to generate 3D orbital trajectory animations for the SPARCS CubeSat and the International Space Station (ISS). 

## Files Included

* `sparcs_animation.m` — Generates the orbital animation for the SPARCS CubeSat based on its Two-Line Element (TLE) data.
* `iss_animation.m` — Generates an orbital animation for the ISS by pulling orbital data directly from a designated web source.

## Customization & Flexibility

These scripts are built to be easily adaptable for other spaceflight simulations or orbital mechanics projects:

* **Animate Any Satellite:** In the `sparcs_animation.m` file, you are not limited to just SPARCS. You can replace the default SPARCS TLE string with any other satellite's TLE. Simply paste in a new TLE to instantly visualize a completely different orbit.
* **Custom Data Sources:** The `iss_animation.m` script pulls its data from a specific website URL. You can easily replace this URL in the code with any other valid endpoint or database (such as CelesTrak or Space-Track) to fetch live or updated parameters for different targets.

## How to Use

1. Clone this repository or download the `.m` files to your local machine.
2. Open MATLAB and ensure your Current Folder is set to the directory containing the downloaded scripts.
3. Open either `sparcs_animation.m` or `iss_animation.m`.
4. *(Optional)* Swap out the TLE or the website URL as described in the customization section above.
5. Click **Run** or type the script name in the Command Window. A figure window will launch displaying the orbital animation.

## Requirements

* MATLAB 
* *Depending on the specific plotting functions used, the Aerospace Toolbox or Mapping Toolbox may be required to render the Earth models.*
