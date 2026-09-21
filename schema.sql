begin;
-- Run once, then enable Authentication > Anonymous Sign-Ins.
create table public.profiles (id uuid primary key references auth.users(id) on delete cascade, name text not null check(char_length(trim(name)) between 2 and 60));
create table public.ideas (id uuid primary key default gen_random_uuid(), user_id uuid not null references public.profiles(id), author_name text not null, title text not null check(char_length(trim(title)) between 1 and 100), body text not null check(char_length(trim(body)) between 1 and 4000), created_at timestamptz not null default now());
create table public.votes (idea_id uuid references public.ideas(id) on delete cascade, user_id uuid references public.profiles(id) on delete cascade, value smallint not null default 1 check(value in (-1,1)), primary key(idea_id,user_id));
create table public.comments (id uuid primary key default gen_random_uuid(), idea_id uuid not null references public.ideas(id) on delete cascade, user_id uuid not null references public.profiles(id), author_name text not null, body text not null check(char_length(trim(body)) between 1 and 2000), created_at timestamptz not null default now());
create index comments_idea_idx on public.comments(idea_id);
alter table public.profiles enable row level security;
alter table public.ideas enable row level security;
alter table public.votes enable row level security;
alter table public.comments enable row level security;
revoke all on public.profiles,public.ideas,public.votes,public.comments from anon,authenticated;
grant select,insert,update on public.profiles to authenticated;
grant select on public.ideas,public.votes,public.comments to anon,authenticated;
grant insert on public.ideas,public.votes,public.comments to authenticated;
grant update,delete on public.votes to authenticated;
create policy "Read own profile" on public.profiles for select to authenticated using(id=(select auth.uid()));
create policy "Create own profile" on public.profiles for insert to authenticated with check(id=(select auth.uid()));
create policy "Rename own profile" on public.profiles for update to authenticated using(id=(select auth.uid())) with check(id=(select auth.uid()));
create policy "Read ideas" on public.ideas for select to anon,authenticated using(true);
create policy "Read votes" on public.votes for select to anon,authenticated using(true);
create policy "Read comments" on public.comments for select to anon,authenticated using(true);
create policy "Post own ideas" on public.ideas for insert to authenticated with check(user_id=(select auth.uid()) and author_name=(select name from public.profiles where id=(select auth.uid())));
create policy "Post own comments" on public.comments for insert to authenticated with check(user_id=(select auth.uid()) and author_name=(select name from public.profiles where id=(select auth.uid())));
create policy "Vote as self" on public.votes for insert to authenticated with check(user_id=(select auth.uid()));
create policy "Remove own vote" on public.votes for delete to authenticated using(user_id=(select auth.uid()));

create policy "Change own vote" on public.votes for update to authenticated using(user_id=(select auth.uid())) with check(user_id=(select auth.uid()));
commit;
