// Deterministic radial layout. Only edges supplied by the extractor shape the graph.
(function (root) {
  function layoutGraph(entries, edges, preferredRoot) {
    const ids = entries.map(entry => entry.id).sort();
    const known = new Set(ids);
    const adjacent = new Map(ids.map(id => [id, new Set()]));
    const outgoing = new Map(ids.map(id => [id, 0]));
    const realEdges = edges.filter(edge => known.has(edge.from) && known.has(edge.to) && edge.from !== edge.to);
    for (const edge of realEdges) {
      adjacent.get(edge.from).add(edge.to);
      adjacent.get(edge.to).add(edge.from);
      outgoing.set(edge.from, outgoing.get(edge.from) + 1);
    }
    const rank = (a, b) => outgoing.get(b) - outgoing.get(a) || a.localeCompare(b);
    const hub = known.has(preferredRoot) ? preferredRoot : [...ids].sort(rank)[0];
    const positions = new Map();
    const treePairs = new Set();
    const visited = new Set();
    const componentRoots = hub ? [hub, ...ids.filter(id => id !== hub).sort(rank)] : [];
    let island = 0;
    let mainDepth = 0;

    for (const start of componentRoots) {
      if (visited.has(start)) continue;
      island++;
      const children = new Map();
      const depth = new Map([[start, 0]]);
      const queue = [start];
      visited.add(start);
      for (let index = 0; index < queue.length; index++) {
        const current = queue[index];
        const next = [...adjacent.get(current)].sort(rank);
        children.set(current, []);
        for (const neighbor of next) {
          if (visited.has(neighbor)) continue;
          visited.add(neighbor);
          depth.set(neighbor, depth.get(current) + 1);
          children.get(current).push(neighbor);
          treePairs.add([current, neighbor].sort().join('|'));
          queue.push(neighbor);
        }
      }
      const maxDepth = Math.max(...depth.values());
      if (island === 1) mainDepth = maxDepth;
      const mainRadius = 360 + Math.max(0, mainDepth - 1) * 290;
      const origin = island === 1 ? {x:0, y:0} : {
        x:(island % 2 ? 1 : -1) * Math.min(500, 190 * island),
        y:mainRadius + 230 + Math.floor((island - 2) / 2) * 360,
      };
      const size = new Map();
      function subtree(id) {
        const count = 1 + (children.get(id) || []).reduce((sum, child) => sum + subtree(child), 0);
        size.set(id, count);
        return count;
      }
      subtree(start);
      positions.set(start, {...origin, depth:0, component:island});
      function place(id, first, last) {
        const level = depth.get(id);
        const angle = (first + last) / 2;
        const radius = (island === 1 ? 360 + (level - 1) * 290 : 165 + (level - 1) * 175);
        positions.set(id, {
          x:origin.x + Math.cos(angle) * radius,
          y:origin.y + Math.sin(angle) * radius,
          depth:level,
          component:island,
        });
        distribute(children.get(id) || [], first, last);
      }
      function distribute(siblings, first, last) {
        if (!siblings.length) return;
        const available = last - first;
        const minimum = siblings.length > 1 && available === Math.PI * 2 ? Math.min(.34, available / siblings.length) : 0;
        const extras = siblings.map(child => Math.sqrt(size.get(child)));
        const total = extras.reduce((sum, value) => sum + value, 0);
        let cursor = first;
        siblings.forEach((child, index) => {
          const span = minimum + (available - minimum * siblings.length) * extras[index] / total;
          place(child, cursor, cursor + span);
          cursor += span;
        });
      }
      distribute(children.get(start) || [], -Math.PI / 2, Math.PI * 1.5);
    }

    // Separate labels without changing graph topology or the chosen central object.
    for (let iteration = 0; iteration < 48; iteration++) {
      for (let i = 0; i < ids.length; i++) {
        for (let j = i + 1; j < ids.length; j++) {
          const a = positions.get(ids[i]), b = positions.get(ids[j]);
          let dx = b.x - a.x, dy = b.y - a.y;
          let distance = Math.hypot(dx, dy);
          if (distance >= 148) continue;
          if (distance < .001) { dx = 1; dy = 0; distance = 1; }
          const shift = (148 - distance) * .38;
          const ux = dx / distance, uy = dy / distance;
          if (ids[i] !== hub) { a.x -= ux * shift; a.y -= uy * shift; }
          if (ids[j] !== hub) { b.x += ux * shift; b.y += uy * shift; }
        }
      }
    }
    const maxX = Math.max(450, ...[...positions.values()].map(position => Math.abs(position.x)));
    const maxY = Math.max(370, ...[...positions.values()].map(position => Math.abs(position.y)));
    const width = Math.ceil((maxX + 190) * 2);
    const height = Math.ceil((maxY + 190) * 2) + 130;
    for (const position of positions.values()) {
      position.x += width / 2;
      position.y += (height - 130) / 2 + 130;
    }
    return {hub, outgoingCount:outgoing.get(hub) || 0, positions, treePairs, width, height, edgeCount:realEdges.length};
  }
  function layoutOverview(data) {
    const nodeById = new Map(data.nodes.map(node => [node.id, node]));
    const orderedAreas = [...data.areas].sort((a, b) =>
      data.nodes.filter(node => node.area === b).length - data.nodes.filter(node => node.area === a).length
      || a.localeCompare(b));
    const centerArea = orderedAreas[0];
    const areaCenters = new Map([[centerArea, {x:0, y:0}]]);
    const others = orderedAreas.slice(1);
    others.forEach((area, index) => {
      const angle = -Math.PI / 2 + index * Math.PI * 2 / others.length;
      areaCenters.set(area, {x:Math.cos(angle) * 2800, y:Math.sin(angle) * 1700});
    });
    const positions = new Map();
    const treePairs = new Set();
    const areaRadius = new Map();
    for (const area of orderedAreas) {
      const entries = data.nodes.filter(node => node.area === area);
      const ids = new Set(entries.map(node => node.id));
      const edges = data.edges.filter(edge => edge.kind === 'type' && ids.has(edge.from) && ids.has(edge.to));
      const local = layoutGraph(entries, edges);
      const origin = local.positions.get(local.hub);
      const maxDistance = Math.max(1, ...[...local.positions.values()].map(p =>
        Math.hypot(p.x - origin.x, p.y - origin.y)));
      const radius = area === centerArea ? 840 : 540;
      const scale = radius / maxDistance;
      const center = areaCenters.get(area);
      areaRadius.set(area, radius);
      for (const entry of entries) {
        const p = local.positions.get(entry.id);
        positions.set(entry.id, {
          x:center.x + (p.x - origin.x) * scale,
          y:center.y + (p.y - origin.y) * scale,
        });
      }
      for (const pair of local.treePairs) treePairs.add(pair);
    }
    const maxX = Math.max(3200, ...[...positions.values()].map(p => Math.abs(p.x)));
    const maxY = Math.max(2200, ...[...positions.values()].map(p => Math.abs(p.y)));
    const width = Math.ceil((maxX + 300) * 2);
    const height = Math.ceil((maxY + 300) * 2);
    for (const p of positions.values()) { p.x += width / 2; p.y += height / 2; }
    for (const center of areaCenters.values()) { center.x += width / 2; center.y += height / 2; }
    return {positions, areaCenters, areaRadius, treePairs, centerArea, width, height,
      edgeCount:data.edges.filter(edge => edge.kind === 'type'
        && nodeById.has(edge.from) && nodeById.has(edge.to)).length};
  }
  const api = {layoutGraph, layoutOverview};
  if (typeof module !== 'undefined' && module.exports) module.exports = api;
  root.DomainGraphLayout = api;
})(typeof globalThis !== 'undefined' ? globalThis : this);
