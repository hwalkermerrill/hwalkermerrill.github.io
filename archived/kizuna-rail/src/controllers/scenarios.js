import { Router } from 'express';

const router = Router();

// The home page for challenge scenarios
router.get('/', (req, res) => {
    res.render('scenarios/index', { title: 'Challenge Scenarios' });
});

// Scenario: Emergency handoff, a family emergency situation
router.get('/emergency-handoff', (req, res) => {
    res.render('scenarios/emergency-handoff', { title: 'Emergency Handoff' });
});

export default router;