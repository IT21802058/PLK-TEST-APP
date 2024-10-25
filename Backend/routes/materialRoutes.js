import express from 'express';
import {createMaterial, getAllMaterials, getMaterialById, updateMaterialQuantity, deleteMaterial} from '../controllers/materialController.js';
// - **POST /api/material** - create material
// - **GET /api/material/materiallist/** - get all materials
// - **GET /api/material/:id** - fetch one material
// - **PUT /api/material/update-material/:id** - update material
// - **DELETE /api/material/remove-material/:id** - remove one material

const router = express.Router();


router.post('/', createMaterial);
router.get('/materiallist/', getAllMaterials);
router.get('/:id', getMaterialById);
router.put('/update-material/:id', updateMaterialQuantity);
router.delete('/remove-material/:id', deleteMaterial);

export default router;
