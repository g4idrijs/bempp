import dolfin as _dolfin
from scipy.sparse import lil_matrix

def boundary_grid_from_fenics_mesh(fenics_mesh):
    """
    Return a boundary grid from a FEniCS Mesh.
    """
    from bempp import grid_from_element_data

    bm = _dolfin.BoundaryMesh(fenics_mesh, "exterior", False)
    bm_coords = bm.coordinates()
    bm_cells  = bm.cells()
    bempp_boundary_grid = grid_from_element_data(bm_coords.transpose(),bm_cells.transpose())
    return bempp_boundary_grid

def fenics_to_bempp_trace(fenics_space):
    """
    Returns tuple (space,mass_matrix,trace_matrix)
    """

    family,degree = fenics_space_info(fenics_space)

    if family=="Lagrange":
        if degree==1:
            import p1_coupling
            return p1_coupling.p1_trace(fenics_space)
        else:
            raise NotImplementedError()
    else:
        raise NotImplementedError()

def fenics_space_info(fenics_space):
    """
    Returns tuple (family,degree) containing information about a FEniCS space
    """

    element = fenics_space.ufl_element()
    family = element.family()
    degree = element.degree()
    return (family,degree)