Hypervis
==========
A Hypergraph visualisation tool written in Processing language. 

Features:
---------
 - Subset-, edge- and Zykov standard drawing of hyperedges.
 - Export visualisation in svg and pdf format.
 - Circular and Square drawing canvas.
 - Adjusting the shapes of the vertices.
 - Fruchterman-Reingold and Eades's Spring layout for drawing the associated graph.

 
Planned Features:
-----------------
- Allowing more user interaction.


Third-party library dependencies
============
* Java
 - la4j
* Processing 
 - G4P GUI Builder 
 - PeasyCam

How to use
==========
* ``Processing 3:`` install it at https://processing.org/
* Install the dependencies.
  - Processing
    - From Menubar: Tools > Add Tool..
    - Navigate to libraries Tab, Search for G4P and PeasyCam, and install them.
  - Java
   - la4j.jar can be found in code/ directory. You do not need to install it, as Processing expects external java libraries to be in code/ directory. 
* Open ``Hypervis.pde`` in Processing application and run it.
* Hypervis assumes the hypergraph is stored in a text file, where each line corresponds to a hyperedge with its vertices separated by comma (,).
* For further information (e.g. how to load a hypergraph and visualise it), please watch the ``demo:`` https://www.youtube.com/watch?v=16iXlXGsUf4


Citing Hypervis
=================

If you use ``Hypervis`` in a scientific publication, we would appreciate citations to the following paper:

   `Hypergraph drawing by force-directed placement <https://link.springer.com/chapter/10.1007/978-3-319-64471-4_31>`_, Arafat, Naheed Anjum and Bressan, Stéphane, DEXA 2020.
 
You can use the following BibTeX entry:

.. code:: RST

  @inproceedings{
  arafat2017hypergraph,
  title={Hypergraph drawing by force-directed placement},
  author={Arafat, Naheed Anjum and Bressan, Stéphane},
  booktitle={International Conference on Database and Expert Systems Applications},
  pages={387--394},
  year={2017},
  organization={Springer}
  }
