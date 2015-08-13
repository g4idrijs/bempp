from cython.operator cimport dereference as deref
from bempp_ext.utils cimport Matrix
from bempp_ext.utils.shared_ptr cimport reverse_const_pointer_cast
from bempp_ext.utils.shared_ptr cimport const_pointer_cast

cdef class Space:
    """ Space of functions defined on a grid

        Attributes
        ----------

        grid : Grid
            Grid over which to discretize the space.

        dtype : numpy.dtype
            Type of the basis functions in this space.

        codomain_dimension : int
            Number of components of values of functions in this space.

        domain_dimension : int
            Dimension of the domain on which the space is defined.

        global_dof_count : int
            Number of global degrees of freedom.

        flat_local_dof_count : int
            Total number of local degrees of freedom.

        global_dof_interpolation_points : np.ndarray 
            (3xN) matrix of global interpolation points for the space,
            where each column is the coordinate of an interpolation point.

        global_dof_interpolation_points : np.ndarray
            (3xN) matrix of normal directions associated with the interpolation points.

        Notes
        -----
        A space instance should always be created using the function 'bempp.function_space'.

    """


    def __cinit__(self):
        pass

    def __init__(self):
        super(Space, self).__init__()

    def __dealloc__(self):
        self.impl_.reset()

    property dtype:
        """ Type of the basis functions in this space. """
        def __get__(self):
            from numpy import dtype
            return dtype('float64');

    property codomain_dimension:
        """ Number of components of values of functions in this space (e.g. 1 for scalar functions). """
        def __get__(self):
            return deref(self.impl_).codomainDimension()

    property grid:
        """ The underlyign grid for the space. """
        def __get__(self):
            cdef Grid result = Grid.__new__(Grid)
            result.impl_ = const_pointer_cast[c_Grid](deref(self.impl_).grid())
            return result

    property domain_dimension:
        """ Dimension of the domain on which the space is defined (default 2). """

        def __get__(self):
            return deref(self.impl_).domainDimension()

    property global_dof_count:
        """ Number of global degrees of freedom. """

        def __get__(self):
            return deref(self.impl_).globalDofCount()

    property flat_local_dof_count:
        """ Total number of local degrees of freedom. """

        def __get__(self):
            return deref(self.impl_).flatLocalDofCount()

    def is_compatible(self,Space other):
        """ Test if both spaces have the same global degrees of freedom. """

        return deref(self.impl_).spaceIsCompatible(deref(other.impl_))


    def get_global_dofs(self,Entity0 element):

        cdef vector[int] global_dofs_vec
        cdef vector[double] local_dof_weights_vec
        deref(self.impl_).getGlobalDofs(deref(element.impl_),global_dofs_vec, local_dof_weights_vec)
        return (global_dofs_vec,local_dof_weights_vec) 
        
           
    property global_dof_interpolation_points:
        """ (3xN) matrix of global interpolation points for the space, where each column is the
            coordinate of an interpolation points. """

        def __get__(self):
            cdef Matrix[double] data
            deref(self.impl_).getGlobalDofInterpolationPoints(data)
            return eigen_matrix_to_np_float64(data)

    property global_dof_normals:
        """ (3xN) matrix of normal directions associated with the interpolation points. """

        def __get__(self):
            cdef Matrix[double] data
            deref(self.impl_).getNormalsAtGlobalDofInterpolationPoints(data)
            return eigen_matrix_to_np_float64(data)

def function_space(Grid grid, kind, order, domains=None, cbool closed=True):
    """ 

    Return a space defined over a given grid.

    Parameters
    ----------
    grid : bempp.Grid
        The grid object over which the space is defined.

    kind : string
        The type of space. Currently, the following types
        are supported:
        "P" : Continuous and piecewise polynomial functions.
        "DP" : Discontinuous and elementwise polynomial functions.

    order : int
        The order of the space, e.g. 0 for piecewise const, 1 for
        piecewise linear functions.

    domains : list
        List of integers specifying a list of physical entities
        of subdomains that should be included in the space.

    closed : bool
        Specifies whether the space is defined on a closed
        or open subspace.

    Notes
    -----
    The most frequent used types are the space of piecewise constant
    functions (kind="DP", order=0) and the space of continuous,
    piecewise linear functions (kind="P", order=1).

    This is a factory function that initializes a space object. To 
    see a detailed help for space objects see the documentation
    of the instantiated object.

    Examples
    --------
    To initialize a space of piecewise constant functions use

    >>> space = function_space(grid,"DP",0)

    To initialize a space of continuous, piecewise linear functions, use

    >>> space = function_space(grid,"P",1)

    """

    cdef Space s = Space()
    if kind=="P":
        if not (order>=1 and order <=10):
            raise ValueError("Order must be between 1 and 10")
        if (order==1):
            if domains is None:
                s.impl_.assign(reverse_const_pointer_cast(
                        shared_ptr[c_Space[double]](adaptivePiecewiseLinearContinuousScalarSpace[double](grid.impl_))))
            else:
                s.impl_.assign(reverse_const_pointer_cast(
                        shared_ptr[c_Space[double]](adaptivePiecewiseLinearContinuousScalarSpace[double](grid.impl_, domains, closed))))
        else:
            if domains is None:
                s.impl_.assign(reverse_const_pointer_cast(
                        shared_ptr[c_Space[double]](adaptivePiecewisePolynomialContinuousScalarSpace[double](grid.impl_, order))))
            else:
                s.impl_.assign(reverse_const_pointer_cast(
                        shared_ptr[c_Space[double]](adaptivePiecewisePolynomialContinuousScalarSpace[double](grid.impl_, order, domains, closed))))
    elif kind=="DP":
        if not (order>=0 and order <=10):
            raise ValueError("Order must be between 0 and 10")
        if (order==0):
            if domains is None:
                s.impl_.assign(reverse_const_pointer_cast(
                        shared_ptr[c_Space[double]](adaptivePiecewiseConstantScalarSpace[double](grid.impl_))))
            else:
                s.impl_.assign(reverse_const_pointer_cast(
                        shared_ptr[c_Space[double]](adaptivePiecewiseConstantScalarSpace[double](grid.impl_, domains, closed))))
        else:
            if domains is None:
                s.impl_.assign(reverse_const_pointer_cast(
                        shared_ptr[c_Space[double]](adaptivePiecewisePolynomialDiscontinuousScalarSpace[double](grid.impl_, order))))
            else:
                s.impl_.assign(reverse_const_pointer_cast(
                        shared_ptr[c_Space[double]](adaptivePiecewisePolynomialDiscontinuousScalarSpace[double](grid.impl_, order, domains, closed))))
    elif kind=="RT":
        if order!=0:
            raise ValueError("Only 0 order Raviart-Thomas spaces are implemented.")
        if domains is None:
            s.impl_.assign(reverse_const_pointer_cast(
                    shared_ptr[c_Space[double]](adaptiveRaviartThomas0VectorSpace[double](grid.impl_))))
        else:
            s.impl_.assign(reverse_const_pointer_cast(
                    shared_ptr[c_Space[double]](adaptiveRaviartThomas0VectorSpace[double](grid.impl_, domains, closed))))
    else:
        raise ValueError("Unknown kind")

    return s


