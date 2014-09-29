# This file was automatically generated by SWIG (http://www.swig.org).
# Version 2.0.11
#
# Do not make changes to this file unless you know what you are doing--modify
# the SWIG interface file instead.

package FeffPath;
use base qw(Exporter);
use base qw(DynaLoader);
package FeffPathc;
bootstrap FeffPath;
package FeffPath;
@EXPORT = qw();

# ---------- BASE METHODS -------------

package FeffPath;

sub TIEHASH {
    my ($classname,$obj) = @_;
    return bless $obj, $classname;
}

sub CLEAR { }

sub FIRSTKEY { }

sub NEXTKEY { }

sub FETCH {
    my ($self,$field) = @_;
    my $member_func = "swig_${field}_get";
    $self->$member_func();
}

sub STORE {
    my ($self,$field,$newval) = @_;
    my $member_func = "swig_${field}_set";
    $self->$member_func($newval);
}

sub this {
    my $ptr = shift;
    return tied(%$ptr);
}


# ------- FUNCTION WRAPPERS --------

package FeffPath;

*add_scatterer = *FeffPathc::add_scatterer;
*create_path = *FeffPathc::create_path;
*clear_path = *FeffPathc::clear_path;
*make_path = *FeffPathc::make_path;
*cleanup = *FeffPathc::cleanup;
*onepath_ = *FeffPathc::onepath_;
*set_evec = *FeffPathc::set_evec;
*get_evec = *FeffPathc::get_evec;
*get_xivec = *FeffPathc::get_xivec;
*get_ri = *FeffPathc::get_ri;
*get_beta = *FeffPathc::get_beta;
*get_eta = *FeffPathc::get_eta;
*get_k = *FeffPathc::get_k;
*get_real_phc = *FeffPathc::get_real_phc;
*get_mag_feff = *FeffPathc::get_mag_feff;
*get_pha_feff = *FeffPathc::get_pha_feff;
*get_red_fact = *FeffPathc::get_red_fact;
*get_lam = *FeffPathc::get_lam;
*get_rep = *FeffPathc::get_rep;

############# Class : FeffPath::FEFFPATH ##############

package FeffPath::FEFFPATH;
use vars qw(@ISA %OWNER %ITERATORS %BLESSEDMEMBERS);
@ISA = qw( FeffPath );
%OWNER = ();
%ITERATORS = ();
*swig_index_get = *FeffPathc::FEFFPATH_index_get;
*swig_index_set = *FeffPathc::FEFFPATH_index_set;
*swig_nleg_get = *FeffPathc::FEFFPATH_nleg_get;
*swig_nleg_set = *FeffPathc::FEFFPATH_nleg_set;
*swig_deg_get = *FeffPathc::FEFFPATH_deg_get;
*swig_deg_set = *FeffPathc::FEFFPATH_deg_set;
*swig_rat_get = *FeffPathc::FEFFPATH_rat_get;
*swig_rat_set = *FeffPathc::FEFFPATH_rat_set;
*swig_ipot_get = *FeffPathc::FEFFPATH_ipot_get;
*swig_ipot_set = *FeffPathc::FEFFPATH_ipot_set;
*swig_iorder_get = *FeffPathc::FEFFPATH_iorder_get;
*swig_iorder_set = *FeffPathc::FEFFPATH_iorder_set;
*swig_nnnn_get = *FeffPathc::FEFFPATH_nnnn_get;
*swig_nnnn_set = *FeffPathc::FEFFPATH_nnnn_set;
*swig_json_get = *FeffPathc::FEFFPATH_json_get;
*swig_json_set = *FeffPathc::FEFFPATH_json_set;
*swig_verbose_get = *FeffPathc::FEFFPATH_verbose_get;
*swig_verbose_set = *FeffPathc::FEFFPATH_verbose_set;
*swig_ipol_get = *FeffPathc::FEFFPATH_ipol_get;
*swig_ipol_set = *FeffPathc::FEFFPATH_ipol_set;
*swig_evec_get = *FeffPathc::FEFFPATH_evec_get;
*swig_evec_set = *FeffPathc::FEFFPATH_evec_set;
*swig_elpty_get = *FeffPathc::FEFFPATH_elpty_get;
*swig_elpty_set = *FeffPathc::FEFFPATH_elpty_set;
*swig_xivec_get = *FeffPathc::FEFFPATH_xivec_get;
*swig_xivec_set = *FeffPathc::FEFFPATH_xivec_set;
*swig_ri_get = *FeffPathc::FEFFPATH_ri_get;
*swig_ri_set = *FeffPathc::FEFFPATH_ri_set;
*swig_beta_get = *FeffPathc::FEFFPATH_beta_get;
*swig_beta_set = *FeffPathc::FEFFPATH_beta_set;
*swig_eta_get = *FeffPathc::FEFFPATH_eta_get;
*swig_eta_set = *FeffPathc::FEFFPATH_eta_set;
*swig_reff_get = *FeffPathc::FEFFPATH_reff_get;
*swig_reff_set = *FeffPathc::FEFFPATH_reff_set;
*swig_ne_get = *FeffPathc::FEFFPATH_ne_get;
*swig_ne_set = *FeffPathc::FEFFPATH_ne_set;
*swig_k_get = *FeffPathc::FEFFPATH_k_get;
*swig_k_set = *FeffPathc::FEFFPATH_k_set;
*swig_real_phc_get = *FeffPathc::FEFFPATH_real_phc_get;
*swig_real_phc_set = *FeffPathc::FEFFPATH_real_phc_set;
*swig_mag_feff_get = *FeffPathc::FEFFPATH_mag_feff_get;
*swig_mag_feff_set = *FeffPathc::FEFFPATH_mag_feff_set;
*swig_pha_feff_get = *FeffPathc::FEFFPATH_pha_feff_get;
*swig_pha_feff_set = *FeffPathc::FEFFPATH_pha_feff_set;
*swig_red_fact_get = *FeffPathc::FEFFPATH_red_fact_get;
*swig_red_fact_set = *FeffPathc::FEFFPATH_red_fact_set;
*swig_lam_get = *FeffPathc::FEFFPATH_lam_get;
*swig_lam_set = *FeffPathc::FEFFPATH_lam_set;
*swig_rep_get = *FeffPathc::FEFFPATH_rep_get;
*swig_rep_set = *FeffPathc::FEFFPATH_rep_set;
sub new {
    my $pkg = shift;
    my $self = FeffPathc::new_FEFFPATH(@_);
    bless $self, $pkg if defined($self);
}

sub DESTROY {
    return unless $_[0]->isa('HASH');
    my $self = tied(%{$_[0]});
    return unless defined $self;
    delete $ITERATORS{$self};
    if (exists $OWNER{$self}) {
        FeffPathc::delete_FEFFPATH($self);
        delete $OWNER{$self};
    }
}

sub DISOWN {
    my $self = shift;
    my $ptr = tied(%$self);
    delete $OWNER{$ptr};
}

sub ACQUIRE {
    my $self = shift;
    my $ptr = tied(%$self);
    $OWNER{$ptr} = 1;
}


# ------- VARIABLE STUBS --------

package FeffPath;

*nex = *FeffPathc::nex;
*npatx = *FeffPathc::npatx;
*legtot = *FeffPathc::legtot;
*bohr = *FeffPathc::bohr;
*pi = *FeffPathc::pi;
1;
