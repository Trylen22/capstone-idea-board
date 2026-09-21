begin;
-- Existing votes remain upvotes. Safe to run again.
alter table public.votes add column if not exists value smallint not null default 1 check (value in (-1, 1));
grant update on public.votes to authenticated;
drop policy if exists "Change own vote" on public.votes;
create policy "Change own vote" on public.votes for update to authenticated
  using (user_id = (select auth.uid()))
  with check (user_id = (select auth.uid()));
commit;
