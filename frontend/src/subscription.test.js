import React, { act, useEffect } from 'react';
import { createRoot } from 'react-dom/client';
import axios from 'axios';
import { SubscriptionProvider, useSubscription } from './subscription';
let mockAuth = { user: null, token: null };
jest.mock('./App', () => ({ useAuth: () => mockAuth }));
jest.mock('axios');
jest.mock('./lib/track', () => ({ gaClientId: jest.fn(), trackProductEvent: jest.fn() }));
jest.mock('react-router-dom', () => ({ useNavigate: jest.fn(), useSearchParams: jest.fn(), Link: () => null }));
jest.mock('sonner', () => ({ toast: { error: jest.fn() } }));
let status, root, redirects;
function Probe() {
 status = useSubscription();
 useEffect(() => {
  if (mockAuth.user && !status.loading) redirects.push(status.hasAny || status.error ? '/home' : '/subscribe');
 }, [status.loading, status.hasAny, status.error]);
 return null;
}
const render = () => act(() => root.render(<SubscriptionProvider><Probe /></SubscriptionProvider>));
beforeEach(() => {
 global.IS_REACT_ACT_ENVIRONMENT = true;
 mockAuth = { user: null, token: null }; redirects = []; axios.get.mockReset();
 root = createRoot(document.createElement('div'));
});
afterEach(() => act(() => root.unmount()));
it('waits for paid status after signing in', async () => {
 await render(); let resolve;
 axios.get.mockReturnValue(new Promise(r => { resolve = r; }));
 mockAuth = { user: { id: 'paid' }, token: 'paid-token' }; await render();
 expect(status.loading).toBe(true); expect(redirects).toEqual([]);
 await act(async () => resolve({ data: { subscription_tier: 'legacy' } }));
 expect(redirects).toEqual(['/home']);
});
it('does not treat a failed lookup as a missing subscription', async () => {
 await render(); axios.get.mockRejectedValue(new Error('temporary outage'));
 mockAuth = { user: { id: 'paid' }, token: 'paid-token' }; await render();
 expect(status.error).toBe(true); expect(redirects).toEqual(['/home']);
});
it('ignores a previous session response after logout', async () => {
 let resolve; axios.get.mockReturnValue(new Promise(r => { resolve = r; }));
 mockAuth = { user: { id: 'paid' }, token: 'paid-token' }; await render();
 mockAuth = { user: null, token: null }; await render();
 await act(async () => resolve({ data: { subscription_tier: 'legacy' } }));
 expect(status.hasAny).toBe(false); expect(status.loading).toBe(false);
});
it('preserves confirmed free account routing', async () => {
 await render(); axios.get.mockResolvedValue({ data: { subscription_tier: null } });
 mockAuth = { user: { id: 'free' }, token: 'free-token' }; await render();
 expect(redirects).toEqual(['/subscribe']);
});
