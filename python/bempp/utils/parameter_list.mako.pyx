from cython.operator cimport dereference as deref
from cython.operator cimport address
from libcpp.string cimport string 
from libcpp cimport bool as cbool
from .byte_conversion import convert_to_bytes
from libcpp.vector cimport vector

cdef class _AssemblyParameterList:

    def __cinit__(self, ParameterList base):
        self.base = base

    def __init__(self, ParameterList base):
        pass

    def __dealloc__(self):
        # Pointer deallocated by parent class
        pass

    property boundary_operator_assembly_type:

        def __get__(self):

            cdef char* s = b"options.assembly.boundaryOperatorAssemblyType"
            return (deref(self.impl_).get_string(s)).decode("UTF-8")

        def __set__(self,object value):

            cdef char* s = b"options.assembly.boundaryOperatorAssemblyType"           
            cdef string stringVal = convert_to_bytes(value)

            deref(self.impl_).put_string(s,stringVal)

    property potential_operator_assembly_type:

        def __get__(self):

            cdef char* s = b"options.assembly.potentialOperatorAssemblyType"
            return (deref(self.impl_).get_string(s)).decode("UTF-8")

        def __set__(self,object value):

            cdef char* s = b"options.assembly.potentialOperatorAssemblyType"           
            cdef string stringVal = convert_to_bytes(value)

            deref(self.impl_).put_string(s,stringVal)

    property enable_singular_integral_caching:

        def __get__(self):

            cdef char* s = b"options.assembly.enableSingularIntegralCaching"
            return (deref(self.impl_).get_string(s))

        def __set__(self,cbool value):

            cdef char* s = b"options.assembly.enableSingularIntegralCaching"           
            deref(self.impl_).put_bool(s,value)

cdef class _NearField:

    def __init__(self,_QuadratureParameterList base):
        pass

    def __cinit__(self,_QuadratureParameterList base):
        self.base = base


    property max_rel_dist:
        def __get__(self):
            cdef char* s = b"options.quadrature.near.maxRelDist"
            return deref(self.impl_).get_double(s)
        def __set__(self, double value):
            cdef char* s = b"options.quadrature.near.maxRelDist"
            deref(self.impl_).put_double(s,value)

    property single_order:
        def __get__(self):
            cdef char* s = b"options.quadrature.near.singleOrder"
            return deref(self.impl_).get_int(s)
        def __set__(self,int value):
            cdef char* s = b"options.quadrature.near.singleOrder"
            deref(self.impl_).put_int(s,value)

    property double_order:
        def __get__(self):
            cdef char* s = b"options.quadrature.near.doubleOrder"
            return deref(self.impl_).get_int(s)
        def __set__(self,int value):
            cdef char* s = b"options.quadrature.near.doubleOrder"
            deref(self.impl_).put_int(s,value)

cdef class _MediumField:

    def __init__(self,_QuadratureParameterList base):
        pass

    def __cinit__(self,_QuadratureParameterList base):
        self.base = base

    property max_rel_dist:
        def __get__(self):
            cdef char* s = b"options.quadrature.medium.maxRelDist"
            return deref(self.impl_).get_double(s)
        def __set__(self, double value):
            cdef char* s = b"options.quadrature.medium.maxRelDist"
            deref(self.impl_).put_double(s,value)

    property single_order:
        def __get__(self):
            cdef char* s = b"options.quadrature.medium.singleOrder"
            return deref(self.impl_).get_int(s)
        def __set__(self,int value):
            cdef char* s = b"options.quadrature.medium.singleOrder"
            deref(self.impl_).put_int(s,value)

    property double_order:
        def __get__(self):
            cdef char* s = b"options.quadrature.medium.doubleOrder"
            return deref(self.impl_).get_int(s)
        def __set__(self,int value):
            cdef char* s = b"options.quadrature.medium.doubleOrder"
            deref(self.impl_).put_int(s,value)
    
cdef class _FarField:

    def __init__(self,_QuadratureParameterList base):
        pass

    def __cinit__(self,_QuadratureParameterList base):
        self.base = base

    property single_order:
        def __get__(self):
            cdef char* s = b"options.quadrature.far.singleOrder"
            return deref(self.impl_).get_int(s)
        def __set__(self,int value):
            cdef char* s = b"options.quadrature.far.singleOrder"
            deref(self.impl_).put_int(s,value)

    property double_order:
        def __get__(self):
            cdef char* s = b"options.quadrature.far.doubleOrder"
            return deref(self.impl_).get_int(s)
        def __set__(self,int value):
            cdef char* s = b"options.quadrature.far.doubleOrder"
            deref(self.impl_).put_int(s,value)

cdef class _QuadratureParameterList:


    def __cinit__(self, ParameterList base):
        self._near = _NearField(self)
        self._medium = _MediumField(self)
        self._far = _FarField(self)
        self.base = base

    def __init__(self, ParameterList base):
        pass

    def __dealloc__(self):
        # Pointer deallocated by parent class
        pass

    property near:
        def __get__(self):
            return self._near
    property medium:
        def __get__(self):
            return self._medium
    property far:
        def __get__(self):
            return self._far

    property double_singular:
        def __get__(self):
            cdef char* s = b"options.quadrature.doubleSingular"
            return (self.impl_).get_int(s)
        def __set__(self,int value):
            cdef char* s = b"options.quadrature.doubleSingular"
            (self.impl_).put_int(s,value)

cdef class _HMatParameterList:

    def __cinit__(self, ParameterList base):
        self.base = base

    def __init__(self, ParameterList base):
        pass

    property assembly_mode:
        def __get__(self):
            cdef char* s = b"options.hmat.hMatAssemblyMode"
            return deref(self.impl_).get_string(s).decode("UTF-8")
        def __set__(self,object value):
            cdef char* s = b"options.hmat.hMatAssemblyMode"
            deref(self.impl_).put_string(s,convert_to_bytes(value))

    property min_block_size:
        def __get__(self):
            cdef char* s = b"options.hmat.minBlockSize"
            return deref(self.impl_).get_int(s)
        def __set__(self,int value):
            cdef char* s = b"options.hmat.minBlockSize"
            deref(self.impl_).put_int(s,value)

    property max_block_size:
        def __get__(self):
            cdef char* s = b"options.hmat.maxBlockSize"
            return deref(self.impl_).get_int(s)
        def __set__(self,int value):
            cdef char* s = b"options.hmat.maxBlockSize"
            deref(self.impl_).put_int(s,value)

    property eta:
        def __get__(self):
            cdef char* s = b"options.hmat.eta"
            return deref(self.impl_).get_double(s)
        def __set__(self,double value):
            cdef char* s = b"options.hmat.eta"
            deref(self.impl_).put_double(s,value)
            
    property eps:
        def __get__(self):
            cdef char* s = b"options.hmat.eps"
            return deref(self.impl_).get_double(s)
        def __set__(self,double value):
            cdef char* s = "b:options.hmat.eps"
            deref(self.impl_).put_double(s,value)

    property max_rank:
        def __get__(self):
            cdef char* s = b"options.hmat.maxRank"
            return deref(self.impl_).get_int(s)
        def __set__(self,int value):
            cdef char* s = b"options.hmat.maxRank"
            deref(self.impl_).put_int(s,value)

    property default_compression_alg:
        def __get__(self):
            cdef char* s = b"options.hmat.defaultCompressionAlg"
            return deref(self.impl_).get_string(s).decode("UTF-8")
        def __set__(self,object value):
            cdef char* s = b"options.hmat.defaultCompressionAlg"
            deref(self.impl_).put_string(s,convert_to_bytes(value))


    

cdef class ParameterList:

    def __cinit__(self):
        self.impl_ = new c_ParameterList()
        self._assembly = _AssemblyParameterList(self)
        self._quadrature = _QuadratureParameterList(self)
        self._hmat = _HMatParameterList(self)
        (<_AssemblyParameterList>self._assembly).impl_ = self.impl_
        (<_QuadratureParameterList>self._quadrature).impl_ = self.impl_
        (<_NearField>self.quadrature.near).impl_ = self.impl_
        (<_MediumField>self.quadrature.medium).impl_ = self.impl_
        (<_FarField>self.quadrature.far).impl_ = self.impl_
        (<_HMatParameterList>self._hmat).impl_ = self.impl_

    def __init__(self):
        pass

    def __dealloc__(self):
        del self.impl_

    property assembly:

        def __get__(self):
            return self._assembly

    property quadrature:

        def __get__(self):
            return self._quadrature

    property hmat:

        def __get__(self):
            return self._hmat





        

        



