--
-- Backstage Developer Portal - PostgreSQL Schema & Initial Seed Dump
-- Database: backstage_plugin_catalog (AWS RDS PostgreSQL 16)
-- Usage to restore on a new installation from scratch:
--   PGPASSWORD="<password>" psql -h <rds_endpoint> -U backstage -d backstage_plugin_catalog -f backstage-schema.sql
--

BEGIN;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. Backstage Knex Migrations tracking table
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

-- 4. Backstage Final Entities table
CREATE TABLE IF NOT EXISTS public.final_entities (
    entity_id UUID PRIMARY KEY REFERENCES public.refresh_state(entity_id) ON DELETE CASCADE,
    hash VARCHAR(255) NOT NULL,
    stitch_ticket UUID NOT NULL,
    final_entity TEXT,
    entity_ref VARCHAR(255) NOT NULL UNIQUE,
    last_updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS final_entities_entity_ref_idx ON public.final_entities (entity_ref);

-- 5. Backstage Entity Relations table
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

-- 7. Backstage Auth Signing Keys table
CREATE TABLE IF NOT EXISTS public.signing_keys (
    id VARCHAR(255) PRIMARY KEY,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    key TEXT NOT NULL
);

-- 8. Initial Seed Data for kube-demo-2026 & backstage-infra
INSERT INTO public.locations (id, type, target)
VALUES
    ('11111111-1111-1111-1111-111111111111', 'url', 'https://github.com/cirodasilvaj/backstage-infra/blob/main/k8s-manifests/backstage/deployment.yaml'),
    ('22222222-2222-2222-2222-222222222222', 'url', 'https://github.com/cirobessa/kube-demo-2026/blob/main/eks/main.tf')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.refresh_state (entity_id, entity_ref, unprocessed_entity, processed_entity, result_hash, unprocessed_hash)
VALUES
    (
        'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
        'component:default/kube-demo-eks',
        '{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"kube-demo-eks","namespace":"default","description":"AWS EKS 1.35 Cluster Infrastructure"},"spec":{"type":"service","lifecycle":"production","owner":"platform-team"}}',
        '{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"kube-demo-eks","namespace":"default","description":"AWS EKS 1.35 Cluster Infrastructure"},"spec":{"type":"service","lifecycle":"production","owner":"platform-team"}}',
        'hash-kube-demo-eks-v1',
        'hash-kube-demo-eks-v1'
    ),
    (
        'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
        'component:default/backstage-portal',
        '{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"backstage-portal","namespace":"default","description":"Backstage Internal Developer Portal backed by AWS RDS PostgreSQL"},"spec":{"type":"website","lifecycle":"production","owner":"platform-team"}}',
        '{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"backstage-portal","namespace":"default","description":"Backstage Internal Developer Portal backed by AWS RDS PostgreSQL"},"spec":{"type":"website","lifecycle":"production","owner":"platform-team"}}',
        'hash-backstage-portal-v1',
        'hash-backstage-portal-v1'
    )
ON CONFLICT (entity_id) DO NOTHING;

INSERT INTO public.final_entities (entity_id, hash, stitch_ticket, final_entity, entity_ref)
VALUES
    (
        'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
        'hash-kube-demo-eks-v1',
        'aaaaaaaa-1111-1111-1111-aaaaaaaaaaaa',
        '{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"kube-demo-eks","namespace":"default","description":"AWS EKS 1.35 Cluster Infrastructure"},"spec":{"type":"service","lifecycle":"production","owner":"platform-team"}}',
        'component:default/kube-demo-eks'
    ),
    (
        'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
        'hash-backstage-portal-v1',
        'bbbbbbbb-2222-2222-2222-bbbbbbbbbbbb',
        '{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"backstage-portal","namespace":"default","description":"Backstage Internal Developer Portal backed by AWS RDS PostgreSQL"},"spec":{"type":"website","lifecycle":"production","owner":"platform-team"}}',
        'component:default/backstage-portal'
    )
ON CONFLICT (entity_id) DO NOTHING;

COMMIT;
