import React from "react";
import { Link } from "react-router-dom";

// Keep The Record 2026 — Official Contest Rules.
// Public, no auth. Linked from the entry form and both app sites.
// Rules text is the source of truth; the playbook defers to it.

const EFFECTIVE = "September 14, 2026";
const VERSION = "1.0";

const Section = ({ n, title, children }) => (
  <section className="scroll-mt-24" id={`s${n}`}>
    <h2 className="font-serif text-xl font-bold text-foreground mb-3">
      {n}. {title}
    </h2>
    <div className="space-y-3 text-base leading-relaxed text-muted-foreground">
      {children}
    </div>
  </section>
);

const TOC = [
  "Sponsor",
  "Who can enter",
  "How to enter",
  "Contest period and stages",
  "The assignment",
  "Posting requirements",
  "Eligibility during the contest",
  "Final submission",
  "Judging",
  "Prizes",
  "Prize conditions and taxes",
  "Your content and our use of it",
  "Your recipes stay yours",
  "Disclosure",
  "Conduct and disqualification",
  "General",
  "Contact",
];

const ContestRulesPage = () => (
  <div className="min-h-screen bg-background text-foreground" data-testid="contest-rules-page">
    <header className="border-b border-border/50 bg-card/50 sticky top-0 z-30">
      <div className="max-w-3xl mx-auto px-4 sm:px-6 py-4 flex items-center justify-between">
        <Link to="/" className="font-serif text-lg font-bold text-foreground">
          Legacy Table
        </Link>
        <a
          href="https://forms.gle/TuiJSZSh1eoB3uQx7"
          className="text-sm font-medium text-primary hover:underline"
          target="_blank"
          rel="noopener noreferrer"
        >
          Enter the contest →
        </a>
      </div>
    </header>

    <div className="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      <div className="mb-8">
        <p className="text-sm uppercase tracking-widest text-primary font-semibold mb-3">
          Keep The Record 2026
        </p>
        <h1 className="font-serif text-3xl md:text-4xl font-bold text-foreground mb-2">
          Official Contest Rules
        </h1>
        <p className="text-muted-foreground">
          Effective {EFFECTIVE} · Version {VERSION}
        </p>
        <p className="mt-4 text-base leading-relaxed text-muted-foreground">
          Keep The Record is a skill-based content contest run by Ubuntu Markets LLC for
          paid users of Kindred and Legacy Table. Entries are judged; no part of winning is
          left to chance. Read these rules before you enter. Where the entry form, the
          participant confirmation, or any campaign post differs from these rules, these
          rules control.
        </p>
      </div>

      <nav className="mb-10 rounded-2xl border border-border bg-card p-5" aria-label="Contents">
        <p className="text-xs uppercase tracking-widest text-muted-foreground font-semibold mb-3">
          Contents
        </p>
        <ol className="grid grid-cols-1 sm:grid-cols-2 gap-x-6 gap-y-1 text-sm list-decimal list-inside">
          {TOC.map((t, i) => (
            <li key={t}>
              <a href={`#s${i + 1}`} className="text-primary hover:underline">
                {t}
              </a>
            </li>
          ))}
        </ol>
      </nav>

      <div className="space-y-10">
        <Section n={1} title="Sponsor">
          <p>
            The contest is sponsored and administered by Ubuntu Markets LLC, a California
            limited liability company ("Ubuntu Markets," "we," "us"), the maker of Kindred
            (heykindred.org) and Legacy Table (legacytable.app). Apple, Google, Meta, TikTok,
            and every other platform named in these rules are not sponsors and have nothing
            to do with this contest.
          </p>
        </Section>

        <Section n={2} title="Who can enter">
          <p>
            You may enter if, at the time you submit the entry form and throughout the
            contest, you are all of the following:
          </p>
          <ul className="list-disc pl-6 space-y-1">
            <li>at least 18 years old, or the age of majority where you live if that is higher;</li>
            <li>
              an active <strong>paid</strong> subscriber to Kindred, Legacy Table, or both, on
              the account you enter with (a free account does not qualify);
            </li>
            <li>
              the holder of a public account on at least one of Instagram, TikTok, Threads,
              Facebook, or LinkedIn from which you will post;
            </li>
            <li>not an employee, contractor, judge, or immediate family or household member of one, of Ubuntu Markets.</li>
          </ul>
          <p>
            The contest is open worldwide and is void where prohibited or restricted by
            law. You are responsible for knowing whether you may lawfully take part where
            you live. A paid subscription is required to enter; there is no free method of
            entry because this is a judged skill contest, not a sweepstakes.
          </p>
        </Section>

        <Section n={3} title="How to enter">
          <p>
            Complete the entry form at{" "}
            <a
              href="https://forms.gle/TuiJSZSh1eoB3uQx7"
              className="text-primary hover:underline"
              target="_blank"
              rel="noopener noreferrer"
            >
              forms.gle/TuiJSZSh1eoB3uQx7
            </a>{" "}
            between <strong>Monday, September 14, 2026</strong> and{" "}
            <strong>Sunday, October 4, 2026 at 11:59 PM Pacific Time</strong>. You will be
            asked for your name, the social handles you will post from, which app you are
            entering with, proof that your subscription is active, and your agreement to
            these rules. We verify paid status within 48 hours and confirm by message.
            Entries that cannot be verified are not accepted. One entry per person; you may
            enter with one app or both, but you compete once.
          </p>
        </Section>

        <Section n={4} title="Contest period and stages">
          <p>The contest runs in three stages. All times are Pacific Time.</p>
          <div className="overflow-x-auto">
            <table className="w-full text-sm border-collapse">
              <thead>
                <tr className="text-left border-b border-border">
                  <th className="py-2 pr-4 font-semibold text-foreground">Stage</th>
                  <th className="py-2 pr-4 font-semibold text-foreground">Dates</th>
                  <th className="py-2 font-semibold text-foreground">What happens</th>
                </tr>
              </thead>
              <tbody>
                <tr className="border-b border-border/60">
                  <td className="py-2 pr-4 align-top">1 · Open the Door</td>
                  <td className="py-2 pr-4 align-top whitespace-nowrap">Sep 14 – Oct 4</td>
                  <td className="py-2">Enrollment open. Post one introduction.</td>
                </tr>
                <tr className="border-b border-border/60">
                  <td className="py-2 pr-4 align-top">2 · The Work</td>
                  <td className="py-2 pr-4 align-top whitespace-nowrap">Oct 5 – Nov 15</td>
                  <td className="py-2">Post at least twice each week following the weekly prompts.</td>
                </tr>
                <tr className="border-b border-border/60">
                  <td className="py-2 pr-4 align-top">3 · The Table</td>
                  <td className="py-2 pr-4 align-top whitespace-nowrap">Nov 16 – Nov 29</td>
                  <td className="py-2">Submit your final entry by Nov 29, 11:59 PM PT.</td>
                </tr>
                <tr className="border-b border-border/60">
                  <td className="py-2 pr-4 align-top">Community vote</td>
                  <td className="py-2 pr-4 align-top whitespace-nowrap">Nov 30 – Dec 4</td>
                  <td className="py-2">Public voting closes Dec 4, 5:00 PM PT.</td>
                </tr>
                <tr>
                  <td className="py-2 pr-4 align-top">Winners announced</td>
                  <td className="py-2 pr-4 align-top whitespace-nowrap">Sat, Dec 5</td>
                  <td className="py-2">Announced from the Kindred and Legacy Table accounts.</td>
                </tr>
              </tbody>
            </table>
          </div>
        </Section>

        <Section n={5} title="The assignment">
          <p>
            <strong>Kindred entrants:</strong> plan a real gathering of your family or
            community on Kindred and document it — who you are bringing together, how the
            plan comes together in the app, and the gathering itself.
          </p>
          <p>
            <strong>Legacy Table entrants:</strong> choose one family recipe saved in Legacy
            Table and document cooking it with the elder or family member who holds it —
            the story, the cook, and the finished dish.
          </p>
          <p>
            Entrants with both apps may combine the two: a gathering planned on Kindred with
            a Legacy Table recipe on the table.
          </p>
        </Section>

        <Section n={6} title="Posting requirements">
          <p>A post counts as a qualifying post only if it is all of the following:</p>
          <ul className="list-disc pl-6 space-y-1">
            <li>public, on one of the platforms listed in Section 2, from a handle you gave on your entry form;</li>
            <li>
              tagged with <strong>#KeepTheRecord</strong>, <strong>#KeepTheRecordContest</strong>, and
              your app tag — <strong>#TheGatheringCypher</strong> for Kindred or{" "}
              <strong>#SetTheLegacyTable</strong> for Legacy Table;
            </li>
            <li>tagging the app account: @heykindred (Instagram, X), @hey.kindred (TikTok), or @legacytable;</li>
            <li>original content you made for this contest, showing real use of the app;</li>
            <li>posted within the stage it is meant for.</li>
          </ul>
          <p>
            Stage 1 requires one introduction post. Stage 2 requires at least two qualifying
            posts in each calendar week (Monday to Sunday). Stage 3 requires one final
            submission (Section 8). Posting more than the minimum is welcome.
          </p>
        </Section>

        <Section n={7} title="Eligibility during the contest">
          <p>
            If you miss the posting minimum in two consecutive weeks of Stage 2, you are no
            longer eligible for a prize. We will tell you in writing. You may keep posting
            and remain part of the campaign. Your paid subscription must stay active through
            December 5, 2026; if it lapses, you are no longer eligible for a prize.
          </p>
        </Section>

        <Section n={8} title="Final submission">
          <p>
            Between November 16 and November 29, 2026 (11:59 PM PT), submit the link to your
            final entry through the final submission form we send to eligible entrants.
          </p>
          <p>
            <strong>Kindred:</strong> one post or carousel showing the gathering that took
            place, with a visible moment of the plan inside Kindred (the event screen, the
            guest list, or the group) and the people it brought together.
          </p>
          <p>
            <strong>Legacy Table:</strong> one post or video showing the finished dish, the
            recipe card from the app on screen, the elder present or credited, and one line
            on who taught it.
          </p>
          <p>Late submissions are not judged. Early submissions are fine.</p>
        </Section>

        <Section n={9} title="Judging">
          <p>
            Final entries are scored by a panel of three judges from Ubuntu Markets (70% of
            the final score) and by a public community vote (30%). Judges score each entry
            independently on four equally weighted criteria:
          </p>
          <ul className="list-disc pl-6 space-y-1">
            <li><strong>Heritage story</strong> — how clearly the entry tells who these people are and why this gathering or dish matters;</li>
            <li><strong>Real use of the app</strong> — how visibly Kindred or Legacy Table did the work on screen;</li>
            <li><strong>Craft</strong> — quality of the photography, video, writing, and editing;</li>
            <li><strong>Consistency</strong> — the quality and regularity of the entrant's posts across the whole run.</li>
          </ul>
          <p>
            The community vote runs November 30 through December 4, 2026 (5:00 PM PT) on
            posts from the Kindred and Legacy Table accounts. Votes from bots, purchased
            engagement, or duplicate accounts are discarded. Judges' decisions are final and
            binding. Ties are broken by the judges' score on Heritage story.
          </p>
        </Section>

        <Section n={10} title="Prizes">
          <div className="overflow-x-auto">
            <table className="w-full text-sm border-collapse">
              <thead>
                <tr className="text-left border-b border-border">
                  <th className="py-2 pr-4 font-semibold text-foreground">Place</th>
                  <th className="py-2 pr-4 font-semibold text-foreground">Cash (USD)</th>
                  <th className="py-2 font-semibold text-foreground">Subscription</th>
                </tr>
              </thead>
              <tbody>
                <tr className="border-b border-border/60">
                  <td className="py-2 pr-4">First</td>
                  <td className="py-2 pr-4">$600</td>
                  <td className="py-2">One year at the top tier of the app you entered with</td>
                </tr>
                <tr className="border-b border-border/60">
                  <td className="py-2 pr-4">Second</td>
                  <td className="py-2 pr-4">$250</td>
                  <td className="py-2">One year at the next tier above your current plan</td>
                </tr>
                <tr className="border-b border-border/60">
                  <td className="py-2 pr-4">Third</td>
                  <td className="py-2 pr-4">$150</td>
                  <td className="py-2">One year at the next tier above your current plan</td>
                </tr>
                <tr>
                  <td className="py-2 pr-4">Community pick (up to five)</td>
                  <td className="py-2 pr-4">—</td>
                  <td className="py-2">$25 subscription credit, to the top community-vote entrants who did not place</td>
                </tr>
              </tbody>
            </table>
          </div>
          <p>
            Total cash prize pool: $1,000. Subscription prizes are applied to the account you
            entered with and have no cash value. Prizes are not transferable and cannot be
            substituted, except that we may substitute a prize of equal or greater value if
            one becomes unavailable.
          </p>
        </Section>

        <Section n={11} title="Prize conditions and taxes">
          <p>
            Cash prizes are paid within 14 days of announcement by an electronic method that
            works where you live (for example Upwork, Wise, or PayPal). Before we pay, you
            must confirm your identity and eligibility and return any tax form we ask for: a
            Form W-9 if you are a U.S. person, or a Form W-8BEN if you are not. Failure to
            return the form within 14 days of our request forfeits the prize, and we may award
            it to the next-ranked entrant.
          </p>
          <p>
            You are responsible for all taxes, fees, and reporting on any prize under the
            laws of your country, state, or province. Where the law requires, we will report
            prize payments to tax authorities.
          </p>
        </Section>

        <Section n={12} title="Your content and our use of it">
          <p>
            <strong>You keep your content.</strong> You own every post, photo, video, and
            recording you create for this contest.
          </p>
          <p>
            By entering, you give Ubuntu Markets permission to repost and share your contest
            entries — on the Kindred and Legacy Table social accounts, websites, and
            newsletters, and in materials about this contest — with your name and handle
            credited, during the contest and for up to two years after it ends. That is the
            whole license. We will not sell your content, license it to anyone else, or use it
            in paid advertising without asking you first and getting a separate yes.
          </p>
          <p>
            You confirm that your entries are your original work, that you have permission
            from every identifiable person who appears in them (including elders and minors,
            through a parent or guardian), and that they contain no music, footage, or other
            material you do not have the right to use.
          </p>
        </Section>

        <Section n={13} title="Your recipes stay yours">
          <p>
            Nothing in this contest changes who owns what is inside the apps. Recipes, photos,
            voice notes, stories, and gathering plans you save in Legacy Table or Kindred are
            yours. We never sell them, share them, or use them without you, contest or no
            contest. The license in Section 12 covers only the public posts you choose to make
            as contest entries.
          </p>
        </Section>

        <Section n={14} title="Disclosure">
          <p>
            Because you are competing for a prize, every qualifying post must make that
            clear. Including <strong>#KeepTheRecordContest</strong> in the post satisfies this
            requirement. Posts without it do not count and may be treated as a violation of
            platform advertising rules or applicable law, which you are responsible for
            following.
          </p>
        </Section>

        <Section n={15} title="Conduct and disqualification">
          <p>We may disqualify an entrant, at any stage and at our reasonable discretion, who:</p>
          <ul className="list-disc pl-6 space-y-1">
            <li>provides false information on the entry form, including about their subscription;</li>
            <li>uses purchased followers, bots, or engagement pods, or manipulates the community vote;</li>
            <li>posts content that is hateful, harassing, sexually explicit, dangerous, or that infringes anyone's rights;</li>
            <li>violates the terms of the platform they post on, or the terms of service of Kindred or Legacy Table;</li>
            <li>tampers with the contest or acts in a way that we reasonably believe harms other entrants or the campaign.</li>
          </ul>
        </Section>

        <Section n={16} title="General">
          <p>
            <strong>Changes and cancellation.</strong> If fraud, technical failure, or any
            cause beyond our control affects the fairness or proper running of the contest, we
            may modify, suspend, or cancel it and, if cancelled, award prizes based on
            eligible entries received before the cancellation. We will publish any change to
            these rules on this page and update the version number.
          </p>
          <p>
            <strong>Release.</strong> To the extent permitted by law, by entering you release
            Ubuntu Markets LLC and its members, employees, contractors, and judges from any
            claim arising out of your participation or the award, receipt, or use of a
            prize, except claims arising from our own gross negligence or wilful misconduct.
          </p>
          <p>
            <strong>Privacy.</strong> Information you give on the entry form is used to run
            the contest, verify eligibility, and pay prizes, and is handled under the Legacy
            Table and Kindred privacy policies. We do not sell entrant data.
          </p>
          <p>
            <strong>Governing law.</strong> These rules are governed by the laws of the State
            of California, United States, without regard to conflict-of-laws rules. Any
            dispute will be resolved in the state or federal courts located in California,
            except where the law of your place of residence gives you rights that cannot be
            waived.
          </p>
          <p>
            <strong>Winners list.</strong> The names and handles of winners will be published
            on the Kindred and Legacy Table accounts on December 5, 2026 and will be available
            on request for 60 days after that at the contact below.
          </p>
        </Section>

        <Section n={17} title="Contact">
          <p>
            Questions about the contest:{" "}
            <a href="mailto:support@ubuntu-village.org" className="text-primary hover:underline">
              support@ubuntu-village.org
            </a>
            . Ubuntu Markets LLC · legacytable.app · heykindred.org
          </p>
        </Section>
      </div>

      <div className="mt-12 rounded-2xl border border-border bg-card p-6 text-center">
        <p className="font-serif text-xl font-bold text-foreground mb-2">Ready to keep the record?</p>
        <p className="text-sm text-muted-foreground mb-4">
          Enrollment is open September 14 through October 4, 2026.
        </p>
        <a
          href="https://forms.gle/TuiJSZSh1eoB3uQx7"
          className="inline-block rounded-full bg-primary text-primary-foreground px-6 py-3 text-sm font-semibold hover:opacity-90"
          target="_blank"
          rel="noopener noreferrer"
        >
          Enter the contest
        </a>
      </div>
    </div>
  </div>
);

export default ContestRulesPage;
