--
-- Backstage Developer Portal - PostgreSQL Schema & Initial Seed Dump
-- Database: backstage_plugin_catalog (AWS RDS PostgreSQL 16)
-- Includes Kubernetes Cluster (kube-demo-eks) integration annotations
-- Usage to restore on a new installation from scratch:
--   PGPASSWORD="<password>" psql -h <rds_endpoint> -U backstage -d backstage_plugin_catalog -f backstage-schema.sql
--

BEGIN;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. Knex migration tracking tables (used by Backstage backend plugins)
CREATE TABLE IF NOT EXISTS public.knex_migrations (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    batch INTEGER NOT NULL,
    migration_time TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.knex_migrations_lock (
    index SERIAL PRIMARY KEY,
    is_locked INTEGER DEFAULT 0
);

-- 2. Backstage Catalog Locations table
CREATE TABLE IF NOT EXISTS public.locations (
    id UUID PRIMARY KEY,
    type VARCHAR(255) NOT NULL,
    target TEXT NOT NULL
);

-- 3. Backstage Catalog Refresh State table
CREATE TABLE IF NOT EXISTS public.refresh_state (
    entity_id UUID PRIMARY KEY,
    entity_ref VARCHAR(255) NOT NULL UNIQUE,
    unprocessed_entity TEXT NOT NULL,
    processed_entity TEXT,
    cache TEXT,
    errors TEXT NOT NULL DEFAULT '[]',
    next_update_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    last_discovery_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    result_hash VARCHAR(255),
    unprocessed_hash VARCHAR(255)
);

CREATE INDEX IF NOT EXISTS refresh_state_entity_ref_idx ON public.refresh_state (entity_ref);
CREATE INDEX IF NOT EXISTS refresh_state_next_update_at_idx ON public.refresh_state (next_update_at);

-- 4. Backstage Catalog Final Entities table
CREATE TABLE IF NOT EXISTS public.final_entities (
    entity_id UUID PRIMARY KEY REFERENCES public.refresh_state(entity_id) ON DELETE CASCADE,
    hash VARCHAR(255) NOT NULL,
    stitch_ticket UUID NOT NULL,
    final_entity TEXT,
    entity_ref VARCHAR(255) NOT NULL UNIQUE,
    last_updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS final_entities_entity_ref_idx ON public.final_entities (entity_ref);

-- 5. Backstage Catalog Relations table
CREATE TABLE IF NOT EXISTS public.relations (
    originating_entity_id UUID NOT NULL REFERENCES public.refresh_state(entity_id) ON DELETE CASCADE,
    source_entity_ref VARCHAR(255) NOT NULL,
    type VARCHAR(255) NOT NULL,
    target_entity_ref VARCHAR(255) NOT NULL
);

CREATE INDEX IF NOT EXISTS relations_source_entity_ref_idx ON public.relations (source_entity_ref);
CREATE INDEX IF NOT EXISTS relations_target_entity_ref_idx ON public.relations (target_entity_ref);

-- 6. Backstage Catalog Search index table
CREATE TABLE IF NOT EXISTS public.search (
    original_entity_id UUID NOT NULL REFERENCES public.refresh_state(entity_id) ON DELETE CASCADE,
    key VARCHAR(255) NOT NULL,
    value VARCHAR(255),
    original_value VARCHAR(255)
);

CREATE INDEX IF NOT EXISTS search_key_value_idx ON public.search (key, value);

-- 7. Backstage Auth / Signing Keys table
CREATE TABLE IF NOT EXISTS public.signing_keys (
    id VARCHAR(255) PRIMARY KEY,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    key TEXT NOT NULL
);

-- 8. Backstage Kubernetes Cluster Configuration metadata table (persisted for new installations)
CREATE TABLE IF NOT EXISTS public.kubernetes_clusters (
    cluster_name VARCHAR(255) PRIMARY KEY,
    api_server_url TEXT NOT NULL,
    auth_provider VARCHAR(100) NOT NULL DEFAULT 'serviceAccount',
    service_account_name VARCHAR(255) NOT NULL DEFAULT 'backstage',
    service_account_namespace VARCHAR(255) NOT NULL DEFAULT 'backstage',
    skip_tls_verify BOOLEAN NOT NULL DEFAULT TRUE,
    skip_metrics_lookup BOOLEAN NOT NULL DEFAULT FALSE,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

INSERT INTO public.kubernetes_clusters (
    cluster_name, api_server_url, auth_provider, service_account_name, service_account_namespace, skip_tls_verify, skip_metrics_lookup
) VALUES (
    'kube-demo-eks', 'https://kubernetes.default.svc', 'serviceAccount', 'backstage', 'backstage', TRUE, FALSE
) ON CONFLICT (cluster_name) DO UPDATE SET
    api_server_url = EXCLUDED.api_server_url,
    auth_provider = EXCLUDED.auth_provider,
    service_account_name = EXCLUDED.service_account_name,
    service_account_namespace = EXCLUDED.service_account_namespace,
    updated_at = NOW();

-- 9. Initial seed data for kube-demo-2026, backstage-infra & apps-demo-2026
INSERT INTO public.locations (id, type, target)
VALUES
    ('11111111-1111-1111-1111-111111111111', 'file', '/etc/backstage/catalog-entities.yaml'),
    ('22222222-2222-2222-2222-222222222222', 'url', 'https://github.com/cirodasilvaj/apps-demo-2026/blob/main/catalog-info.yaml')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.refresh_state (entity_id, entity_ref, unprocessed_entity, processed_entity, result_hash, unprocessed_hash)
VALUES
    (
        'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
        'resource:default/kube-demo-eks',
        '{"apiVersion":"backstage.io/v1alpha1","kind":"Resource","metadata":{"name":"kube-demo-eks","namespace":"default","description":"AWS EKS 1.35 Kubernetes Cluster connected via In-Cluster ServiceAccount RBAC","annotations":{"backstage.io/kubernetes-id":"kube-demo-eks","backstage.io/kubernetes-namespace":"kube-system"}},"spec":{"type":"kubernetes-cluster","owner":"platform-team"}}',
        '{"apiVersion":"backstage.io/v1alpha1","kind":"Resource","metadata":{"name":"kube-demo-eks","namespace":"default","description":"AWS EKS 1.35 Kubernetes Cluster connected via In-Cluster ServiceAccount RBAC","annotations":{"backstage.io/kubernetes-id":"kube-demo-eks","backstage.io/kubernetes-namespace":"kube-system"}},"spec":{"type":"kubernetes-cluster","owner":"platform-team"}}',
        'hash-kube-demo-eks-v2',
        'hash-kube-demo-eks-v2'
    ),
    (
        'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
        'component:default/backstage-portal',
        '{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"backstage-portal","namespace":"default","description":"Backstage Internal Developer Portal backed by AWS RDS PostgreSQL and linked to EKS","annotations":{"backstage.io/kubernetes-id":"backstage","backstage.io/kubernetes-namespace":"backstage","backstage.io/kubernetes-label-selector":"app=backstage"}},"spec":{"type":"website","lifecycle":"production","owner":"platform-team","dependsOn":["resource:default/kube-demo-eks"]}}',
        '{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"backstage-portal","namespace":"default","description":"Backstage Internal Developer Portal backed by AWS RDS PostgreSQL and linked to EKS","annotations":{"backstage.io/kubernetes-id":"backstage","backstage.io/kubernetes-namespace":"backstage","backstage.io/kubernetes-label-selector":"app=backstage"}},"spec":{"type":"website","lifecycle":"production","owner":"platform-team","dependsOn":["resource:default/kube-demo-eks"]}}',
        'hash-backstage-portal-v2',
        'hash-backstage-portal-v2'
    ),
    (
        'cccccccc-cccc-cccc-cccc-cccccccccccc',
        'component:default/python-demo-app',
        '{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"python-demo-app","namespace":"default","description":"Python 3.12 Flask Demo App on EKS","annotations":{"github.com/project-slug":"cirodasilvaj/apps-demo-2026","backstage.io/kubernetes-id":"python-app","backstage.io/kubernetes-namespace":"apps-demo"}},"spec":{"type":"service","lifecycle":"production","owner":"platform-team","dependsOn":["resource:default/kube-demo-eks"]}}',
        '{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"python-demo-app","namespace":"default","description":"Python 3.12 Flask Demo App on EKS","annotations":{"github.com/project-slug":"cirodasilvaj/apps-demo-2026","backstage.io/kubernetes-id":"python-app","backstage.io/kubernetes-namespace":"apps-demo"}},"spec":{"type":"service","lifecycle":"production","owner":"platform-team","dependsOn":["resource:default/kube-demo-eks"]}}',
        'hash-python-demo-app-v1',
        'hash-python-demo-app-v1'
    ),
    (
        'dddddddd-dddd-dddd-dddd-dddddddddddd',
        'component:default/dotnet-csharp-demo-app',
        '{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"dotnet-csharp-demo-app","namespace":"default","description":"C# .NET 8 Minimal API Demo App on EKS","annotations":{"github.com/project-slug":"cirodasilvaj/apps-demo-2026","backstage.io/kubernetes-id":"dotnet-csharp-app","backstage.io/kubernetes-namespace":"apps-demo"}},"spec":{"type":"service","lifecycle":"production","owner":"platform-team","dependsOn":["resource:default/kube-demo-eks"]}}',
        '{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"dotnet-csharp-demo-app","namespace":"default","description":"C# .NET 8 Minimal API Demo App on EKS","annotations":{"github.com/project-slug":"cirodasilvaj/apps-demo-2026","backstage.io/kubernetes-id":"dotnet-csharp-app","backstage.io/kubernetes-namespace":"apps-demo"}},"spec":{"type":"service","lifecycle":"production","owner":"platform-team","dependsOn":["resource:default/kube-demo-eks"]}}',
        'hash-dotnet-csharp-demo-app-v1',
        'hash-dotnet-csharp-demo-app-v1'
    )
ON CONFLICT (entity_id) DO UPDATE SET
    unprocessed_entity = EXCLUDED.unprocessed_entity,
    processed_entity = EXCLUDED.processed_entity,
    result_hash = EXCLUDED.result_hash,
    unprocessed_hash = EXCLUDED.unprocessed_hash,
    last_discovery_at = NOW();

INSERT INTO public.final_entities (entity_id, hash, stitch_ticket, final_entity, entity_ref)
VALUES
    (
        'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
        'hash-kube-demo-eks-v2',
        'aaaaaaaa-1111-1111-1111-aaaaaaaaaaaa',
        '{"apiVersion":"backstage.io/v1alpha1","kind":"Resource","metadata":{"name":"kube-demo-eks","namespace":"default","description":"AWS EKS 1.35 Kubernetes Cluster connected via In-Cluster ServiceAccount RBAC","annotations":{"backstage.io/kubernetes-id":"kube-demo-eks","backstage.io/kubernetes-namespace":"kube-system"}},"spec":{"type":"kubernetes-cluster","owner":"platform-team"}}',
        'resource:default/kube-demo-eks'
    ),
    (
        'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
        'hash-backstage-portal-v2',
        'bbbbbbbb-2222-2222-2222-bbbbbbbbbbbb',
        '{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"backstage-portal","namespace":"default","description":"Backstage Internal Developer Portal backed by AWS RDS PostgreSQL and linked to EKS","annotations":{"backstage.io/kubernetes-id":"backstage","backstage.io/kubernetes-namespace":"backstage","backstage.io/kubernetes-label-selector":"app=backstage"}},"spec":{"type":"website","lifecycle":"production","owner":"platform-team","dependsOn":["resource:default/kube-demo-eks"]}}',
        'component:default/backstage-portal'
    ),
    (
        'cccccccc-cccc-cccc-cccc-cccccccccccc',
        'hash-python-demo-app-v1',
        'cccccccc-3333-3333-3333-cccccccccccc',
        '{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"python-demo-app","namespace":"default","description":"Python 3.12 Flask Demo App on EKS","annotations":{"github.com/project-slug":"cirodasilvaj/apps-demo-2026","backstage.io/kubernetes-id":"python-app","backstage.io/kubernetes-namespace":"apps-demo"}},"spec":{"type":"service","lifecycle":"production","owner":"platform-team","dependsOn":["resource:default/kube-demo-eks"]}}',
        'component:default/python-demo-app'
    ),
    (
        'dddddddd-dddd-dddd-dddd-dddddddddddd',
        'hash-dotnet-csharp-demo-app-v1',
        'dddddddd-4444-4444-4444-dddddddddddd',
        '{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"dotnet-csharp-demo-app","namespace":"default","description":"C# .NET 8 Minimal API Demo App on EKS","annotations":{"github.com/project-slug":"cirodasilvaj/apps-demo-2026","backstage.io/kubernetes-id":"dotnet-csharp-app","backstage.io/kubernetes-namespace":"apps-demo"}},"spec":{"type":"service","lifecycle":"production","owner":"platform-team","dependsOn":["resource:default/kube-demo-eks"]}}',
        'component:default/dotnet-csharp-demo-app'
    )
ON CONFLICT (entity_id) DO UPDATE SET
    hash = EXCLUDED.hash,
    final_entity = EXCLUDED.final_entity,
    entity_ref = EXCLUDED.entity_ref,
    last_updated_at = NOW();

COMMIT;
