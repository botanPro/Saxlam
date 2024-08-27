/* This file was generated by upbc (the upb compiler) from the input
 * file:
 *
 *     envoy/admin/v3/clusters.proto
 *
 * Do not edit -- your changes will be discarded when the file is
 * regenerated. */

#include <stddef.h>
#include "upb/msg_internal.h"
#include "envoy/admin/v3/clusters.upb.h"
#include "envoy/admin/v3/metrics.upb.h"
#include "envoy/config/cluster/v3/circuit_breaker.upb.h"
#include "envoy/config/core/v3/address.upb.h"
#include "envoy/config/core/v3/base.upb.h"
#include "envoy/config/core/v3/health_check.upb.h"
#include "envoy/type/v3/percent.upb.h"
#include "udpa/annotations/status.upb.h"
#include "udpa/annotations/versioning.upb.h"

#include "upb/port_def.inc"

static const upb_MiniTable_Sub envoy_admin_v3_Clusters_submsgs[1] = {
  {.submsg = &envoy_admin_v3_ClusterStatus_msginit},
};

static const upb_MiniTable_Field envoy_admin_v3_Clusters__fields[1] = {
  {1, UPB_SIZE(0, 0), UPB_SIZE(0, 0), 0, 11, kUpb_FieldMode_Array | (kUpb_FieldRep_Pointer << kUpb_FieldRep_Shift)},
};

const upb_MiniTable envoy_admin_v3_Clusters_msginit = {
  &envoy_admin_v3_Clusters_submsgs[0],
  &envoy_admin_v3_Clusters__fields[0],
  UPB_SIZE(8, 8), 1, kUpb_ExtMode_NonExtendable, 1, 255, 0,
};

static const upb_MiniTable_Sub envoy_admin_v3_ClusterStatus_submsgs[4] = {
  {.submsg = &envoy_type_v3_Percent_msginit},
  {.submsg = &envoy_admin_v3_HostStatus_msginit},
  {.submsg = &envoy_type_v3_Percent_msginit},
  {.submsg = &envoy_config_cluster_v3_CircuitBreakers_msginit},
};

static const upb_MiniTable_Field envoy_admin_v3_ClusterStatus__fields[7] = {
  {1, UPB_SIZE(4, 8), UPB_SIZE(0, 0), kUpb_NoSub, 9, kUpb_FieldMode_Scalar | (kUpb_FieldRep_StringView << kUpb_FieldRep_Shift)},
  {2, UPB_SIZE(1, 1), UPB_SIZE(0, 0), kUpb_NoSub, 8, kUpb_FieldMode_Scalar | (kUpb_FieldRep_1Byte << kUpb_FieldRep_Shift)},
  {3, UPB_SIZE(12, 24), UPB_SIZE(1, 1), 0, 11, kUpb_FieldMode_Scalar | (kUpb_FieldRep_Pointer << kUpb_FieldRep_Shift)},
  {4, UPB_SIZE(16, 32), UPB_SIZE(0, 0), 1, 11, kUpb_FieldMode_Array | (kUpb_FieldRep_Pointer << kUpb_FieldRep_Shift)},
  {5, UPB_SIZE(20, 40), UPB_SIZE(2, 2), 2, 11, kUpb_FieldMode_Scalar | (kUpb_FieldRep_Pointer << kUpb_FieldRep_Shift)},
  {6, UPB_SIZE(24, 48), UPB_SIZE(3, 3), 3, 11, kUpb_FieldMode_Scalar | (kUpb_FieldRep_Pointer << kUpb_FieldRep_Shift)},
  {7, UPB_SIZE(28, 56), UPB_SIZE(0, 0), kUpb_NoSub, 9, kUpb_FieldMode_Scalar | (kUpb_FieldRep_StringView << kUpb_FieldRep_Shift)},
};

const upb_MiniTable envoy_admin_v3_ClusterStatus_msginit = {
  &envoy_admin_v3_ClusterStatus_submsgs[0],
  &envoy_admin_v3_ClusterStatus__fields[0],
  UPB_SIZE(40, 72), 7, kUpb_ExtMode_NonExtendable, 7, 255, 0,
};

static const upb_MiniTable_Sub envoy_admin_v3_HostStatus_submsgs[6] = {
  {.submsg = &envoy_config_core_v3_Address_msginit},
  {.submsg = &envoy_admin_v3_SimpleMetric_msginit},
  {.submsg = &envoy_admin_v3_HostHealthStatus_msginit},
  {.submsg = &envoy_type_v3_Percent_msginit},
  {.submsg = &envoy_type_v3_Percent_msginit},
  {.submsg = &envoy_config_core_v3_Locality_msginit},
};

static const upb_MiniTable_Field envoy_admin_v3_HostStatus__fields[9] = {
  {1, UPB_SIZE(12, 16), UPB_SIZE(1, 1), 0, 11, kUpb_FieldMode_Scalar | (kUpb_FieldRep_Pointer << kUpb_FieldRep_Shift)},
  {2, UPB_SIZE(16, 24), UPB_SIZE(0, 0), 1, 11, kUpb_FieldMode_Array | (kUpb_FieldRep_Pointer << kUpb_FieldRep_Shift)},
  {3, UPB_SIZE(20, 32), UPB_SIZE(2, 2), 2, 11, kUpb_FieldMode_Scalar | (kUpb_FieldRep_Pointer << kUpb_FieldRep_Shift)},
  {4, UPB_SIZE(24, 40), UPB_SIZE(3, 3), 3, 11, kUpb_FieldMode_Scalar | (kUpb_FieldRep_Pointer << kUpb_FieldRep_Shift)},
  {5, UPB_SIZE(4, 4), UPB_SIZE(0, 0), kUpb_NoSub, 13, kUpb_FieldMode_Scalar | (kUpb_FieldRep_4Byte << kUpb_FieldRep_Shift)},
  {6, UPB_SIZE(28, 48), UPB_SIZE(0, 0), kUpb_NoSub, 9, kUpb_FieldMode_Scalar | (kUpb_FieldRep_StringView << kUpb_FieldRep_Shift)},
  {7, UPB_SIZE(8, 8), UPB_SIZE(0, 0), kUpb_NoSub, 13, kUpb_FieldMode_Scalar | (kUpb_FieldRep_4Byte << kUpb_FieldRep_Shift)},
  {8, UPB_SIZE(36, 64), UPB_SIZE(4, 4), 4, 11, kUpb_FieldMode_Scalar | (kUpb_FieldRep_Pointer << kUpb_FieldRep_Shift)},
  {9, UPB_SIZE(40, 72), UPB_SIZE(5, 5), 5, 11, kUpb_FieldMode_Scalar | (kUpb_FieldRep_Pointer << kUpb_FieldRep_Shift)},
};

const upb_MiniTable envoy_admin_v3_HostStatus_msginit = {
  &envoy_admin_v3_HostStatus_submsgs[0],
  &envoy_admin_v3_HostStatus__fields[0],
  UPB_SIZE(48, 80), 9, kUpb_ExtMode_NonExtendable, 9, 255, 0,
};

static const upb_MiniTable_Field envoy_admin_v3_HostHealthStatus__fields[8] = {
  {1, UPB_SIZE(0, 0), UPB_SIZE(0, 0), kUpb_NoSub, 8, kUpb_FieldMode_Scalar | (kUpb_FieldRep_1Byte << kUpb_FieldRep_Shift)},
  {2, UPB_SIZE(1, 1), UPB_SIZE(0, 0), kUpb_NoSub, 8, kUpb_FieldMode_Scalar | (kUpb_FieldRep_1Byte << kUpb_FieldRep_Shift)},
  {3, UPB_SIZE(4, 4), UPB_SIZE(0, 0), kUpb_NoSub, 5, kUpb_FieldMode_Scalar | (kUpb_FieldRep_4Byte << kUpb_FieldRep_Shift)},
  {4, UPB_SIZE(8, 8), UPB_SIZE(0, 0), kUpb_NoSub, 8, kUpb_FieldMode_Scalar | (kUpb_FieldRep_1Byte << kUpb_FieldRep_Shift)},
  {5, UPB_SIZE(9, 9), UPB_SIZE(0, 0), kUpb_NoSub, 8, kUpb_FieldMode_Scalar | (kUpb_FieldRep_1Byte << kUpb_FieldRep_Shift)},
  {6, UPB_SIZE(10, 10), UPB_SIZE(0, 0), kUpb_NoSub, 8, kUpb_FieldMode_Scalar | (kUpb_FieldRep_1Byte << kUpb_FieldRep_Shift)},
  {7, UPB_SIZE(11, 11), UPB_SIZE(0, 0), kUpb_NoSub, 8, kUpb_FieldMode_Scalar | (kUpb_FieldRep_1Byte << kUpb_FieldRep_Shift)},
  {8, UPB_SIZE(12, 12), UPB_SIZE(0, 0), kUpb_NoSub, 8, kUpb_FieldMode_Scalar | (kUpb_FieldRep_1Byte << kUpb_FieldRep_Shift)},
};

const upb_MiniTable envoy_admin_v3_HostHealthStatus_msginit = {
  NULL,
  &envoy_admin_v3_HostHealthStatus__fields[0],
  UPB_SIZE(16, 16), 8, kUpb_ExtMode_NonExtendable, 8, 255, 0,
};

static const upb_MiniTable *messages_layout[4] = {
  &envoy_admin_v3_Clusters_msginit,
  &envoy_admin_v3_ClusterStatus_msginit,
  &envoy_admin_v3_HostStatus_msginit,
  &envoy_admin_v3_HostHealthStatus_msginit,
};

const upb_MiniTable_File envoy_admin_v3_clusters_proto_upb_file_layout = {
  messages_layout,
  NULL,
  NULL,
  4,
  0,
  0,
};

#include "upb/port_undef.inc"
